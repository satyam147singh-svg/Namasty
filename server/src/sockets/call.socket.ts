import { Server, Socket } from 'socket.io';
import { inMemoryDb } from '../database/db';

interface AuthenticatedSocket extends Socket {
  userId?: string;
}

export const setupCallSocketHandlers = (io: Server): void => {
  io.on('connection', (socket: AuthenticatedSocket) => {
    const userId = socket.userId!;

    // 1. Initiate 1-to-1 Call
    socket.on(
      'call:initiate',
      (data: {
        callId: string;
        recipientId: string;
        type: 'voice' | 'video';
      }) => {
        const { callId, recipientId, type } = data;
        const caller = inMemoryDb.users.get(userId);

        console.log(`[WEBRTC] User ${userId} calling ${recipientId} (${type})`);

        // Forward incoming call signal to recipient's personal room
        io.to(`user:${recipientId}`).emit('call:incoming', {
          callId,
          caller: {
            id: userId,
            name: caller?.name || 'Namasty User',
            avatarUrl: caller?.avatarUrl,
            phoneNumber: caller?.phoneNumber,
          },
          type,
          isGroup: false,
        });
      }
    );

    // 2. Accept Incoming Call
    socket.on('call:accept', ({ callId, callerId }: { callId: string; callerId: string }) => {
      console.log(`[WEBRTC] User ${userId} accepted call ${callId}`);
      io.to(`user:${callerId}`).emit('call:accepted', { callId, acceptorId: userId });
    });

    // 3. Reject Call
    socket.on('call:reject', ({ callId, callerId, reason }: { callId: string; callerId: string; reason?: string }) => {
      console.log(`[WEBRTC] Call ${callId} rejected by ${userId}`);
      io.to(`user:${callerId}`).emit('call:rejected', { callId, rejectorId: userId, reason: reason || 'declined' });
    });

    // 4. Exchange WebRTC Signaling (SDP Offer / Answer)
    socket.on(
      'call:signal',
      (data: {
        targetUserId: string;
        callId: string;
        sdp: any;
      }) => {
        const { targetUserId, callId, sdp } = data;
        io.to(`user:${targetUserId}`).emit('call:signal', {
          senderId: userId,
          callId,
          sdp,
        });
      }
    );

    // 5. Trickle ICE Candidates
    socket.on(
      'call:ice_candidate',
      (data: {
        targetUserId: string;
        callId: string;
        candidate: any;
      }) => {
        const { targetUserId, callId, candidate } = data;
        io.to(`user:${targetUserId}`).emit('call:ice_candidate', {
          senderId: userId,
          callId,
          candidate,
        });
      }
    );

    // 6. End Call
    socket.on('call:end', ({ callId, targetUserId }: { callId: string; targetUserId?: string }) => {
      console.log(`[WEBRTC] Call ${callId} ended by ${userId}`);
      if (targetUserId) {
        io.to(`user:${targetUserId}`).emit('call:ended', { callId, senderId: userId });
      }
      socket.to(`call_room:${callId}`).emit('call:ended', { callId, senderId: userId });
    });

    // 7. Group Call (Up to 8 participants)
    socket.on(
      'call:group_initiate',
      (data: {
        callId: string;
        groupId: string;
        recipientIds: string[];
        type: 'voice' | 'video';
      }) => {
        const { callId, groupId, recipientIds, type } = data;
        const caller = inMemoryDb.users.get(userId);

        socket.join(`call_room:${callId}`);

        for (const recipientId of recipientIds) {
          if (recipientId !== userId) {
            io.to(`user:${recipientId}`).emit('call:incoming', {
              callId,
              groupId,
              caller: {
                id: userId,
                name: caller?.name || 'Namasty User',
                avatarUrl: caller?.avatarUrl,
              },
              type,
              isGroup: true,
            });
          }
        }
      }
    );

    // Join Group Call Room
    socket.on('call:group_join', ({ callId }: { callId: string }) => {
      socket.join(`call_room:${callId}`);
      socket.to(`call_room:${callId}`).emit('call:group_user_joined', {
        userId,
        callId,
      });
    });
  });
};

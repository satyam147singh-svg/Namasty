import { Server, Socket } from 'socket.io';
import jwt from 'jsonwebtoken';
import { v4 as uuidv4 } from 'uuid';
import { config } from '../config';
import { inMemoryDb } from '../database/db';
import { AuthTokenPayload, Message, MessageType, MediaMetadata } from '../types';

interface AuthenticatedSocket extends Socket {
  userId?: string;
  phoneNumber?: string;
}

export const setupSocketHandlers = (io: Server): void => {
  // Socket JWT authentication middleware
  io.use((socket: AuthenticatedSocket, next) => {
    const token = socket.handshake.auth?.token || socket.handshake.headers?.authorization?.replace('Bearer ', '');
    if (!token) {
      return next(new Error('Authentication error: Token required.'));
    }

    try {
      const decoded = jwt.verify(token, config.jwtSecret) as AuthTokenPayload;
      socket.userId = decoded.userId;
      socket.phoneNumber = decoded.phoneNumber;
      next();
    } catch (err) {
      return next(new Error('Authentication error: Invalid token.'));
    }
  });

  io.on('connection', (socket: AuthenticatedSocket) => {
    const userId = socket.userId!;
    console.log(`[SOCKET] User connected: ${userId} (Socket: ${socket.id})`);

    // Update user online status
    const user = inMemoryDb.users.get(userId);
    if (user) {
      user.isOnline = true;
      user.lastSeen = new Date();
      io.emit('user:presence', { userId, isOnline: true, lastSeen: user.lastSeen });
    }

    // Join personal room for targeted push/notifications
    socket.join(`user:${userId}`);

    // Join all rooms for active chats/groups this user belongs to
    for (const chat of inMemoryDb.chats.values()) {
      if (chat.participants.some((p) => p.userId === userId)) {
        socket.join(`chat:${chat.id}`);
      }
    }

    // 1. Join a specific chat/group room dynamically
    socket.on('chat:join', ({ chatId }: { chatId: string }) => {
      socket.join(`chat:${chatId}`);
      console.log(`[SOCKET] User ${userId} joined chat:${chatId}`);
    });

    // 2. Typing indicator
    socket.on('chat:typing', ({ chatId, isTyping }: { chatId: string; isTyping: boolean }) => {
      socket.to(`chat:${chatId}`).emit('chat:typing', {
        chatId,
        userId,
        userName: user?.name || 'Someone',
        isTyping,
      });
    });

    // 3. Real-time message sending (Text & Media & Group broadcasts)
    socket.on(
      'message:send',
      (
        data: {
          chatId: string;
          content: string;
          type?: MessageType;
          mediaUrl?: string;
          mediaMetadata?: MediaMetadata;
          mentions?: string[];
          replyToId?: string;
          tempId?: string;
        },
        callback?: (res: any) => void
      ) => {
        try {
          const { chatId, content, type = 'text', mediaUrl, mediaMetadata, mentions, replyToId, tempId } = data;
          const chat = inMemoryDb.chats.get(chatId);

          if (!chat) {
            if (callback) callback({ success: false, message: 'Chat not found' });
            return;
          }

          // Check Group Permissions
          if (chat.type === 'group' || chat.type === 'broadcast') {
            const participant = chat.participants.find((p) => p.userId === userId);
            if (!participant) {
              if (callback) callback({ success: false, message: 'You are not a member of this group' });
              return;
            }

            if (chat.settings?.onlyAdminsCanSend) {
              const isAdmin = participant.role === 'admin' || participant.role === 'super_admin';
              if (!isAdmin) {
                if (callback) callback({ success: false, message: 'Only admins can send messages in this group' });
                return;
              }
            }
          }

          let replyToMessage: Message | undefined;
          if (replyToId) {
            replyToMessage = inMemoryDb.messages.get(replyToId);
          }

          const messageId = uuidv4();
          const newMessage: Message = {
            id: messageId,
            chatId,
            senderId: userId,
            type,
            content,
            mediaUrl,
            mediaMetadata,
            mentions,
            replyToId,
            replyTo: replyToMessage
              ? { id: replyToMessage.id, content: replyToMessage.content, senderId: replyToMessage.senderId }
              : undefined,
            isEdited: false,
            isDeletedForEveryone: false,
            status: 'sent',
            reactions: [],
            seenBy: [{ userId, seenAt: new Date() }],
            createdAt: new Date(),
            updatedAt: new Date(),
          };

          inMemoryDb.messages.set(messageId, newMessage);
          chat.lastMessage = newMessage;
          chat.updatedAt = new Date();

          // Increment unread count for recipients
          for (const p of chat.participants) {
            if (p.userId !== userId) {
              p.unreadCount += 1;
              io.to(`user:${p.userId}`).emit('chat:updated', {
                chatId,
                lastMessage: newMessage,
                unreadCount: p.unreadCount,
              });
            }
          }

          // Broadcast new message to the chat room
          io.to(`chat:${chatId}`).emit('message:new', {
            ...newMessage,
            tempId,
          });

          if (callback) {
            callback({ success: true, message: newMessage, tempId });
          }
        } catch (error: any) {
          console.error('[SOCKET ERROR] message:send', error);
          if (callback) callback({ success: false, message: error.message });
        }
      }
    );

    // 4. Seen-by tracking for Group and Direct Messages
    socket.on('message:seen', ({ chatId, messageIds }: { chatId: string; messageIds: string[] }) => {
      const chat = inMemoryDb.chats.get(chatId);
      if (!chat) return;

      const participant = chat.participants.find((p) => p.userId === userId);
      if (participant) {
        participant.unreadCount = 0;
      }

      for (const mid of messageIds) {
        const msg = inMemoryDb.messages.get(mid);
        if (msg) {
          if (!msg.seenBy.some((s) => s.userId === userId)) {
            msg.seenBy.push({ userId, seenAt: new Date() });
          }
          if (chat.type === 'direct' && msg.senderId !== userId) {
            msg.status = 'read';
          }

          io.to(`chat:${chatId}`).emit('message:seen_update', {
            messageId: mid,
            chatId,
            userId,
            seenBy: msg.seenBy,
            status: chat.type === 'direct' ? 'read' : undefined,
          });
        }
      }
    });

    // 5. Message emoji reactions
    socket.on('message:react', ({ messageId, emoji }: { messageId: string; emoji: string }) => {
      const msg = inMemoryDb.messages.get(messageId);
      if (msg) {
        const existingIdx = msg.reactions.findIndex((r) => r.userId === userId);
        if (existingIdx !== -1) {
          if (msg.reactions[existingIdx].emoji === emoji) {
            msg.reactions.splice(existingIdx, 1);
          } else {
            msg.reactions[existingIdx].emoji = emoji;
          }
        } else {
          msg.reactions.push({ userId, emoji, createdAt: new Date() });
        }

        io.to(`chat:${msg.chatId}`).emit('message:reaction_update', {
          messageId,
          chatId: msg.chatId,
          reactions: msg.reactions,
        });
      }
    });

    // Disconnect handling
    socket.on('disconnect', () => {
      console.log(`[SOCKET] User disconnected: ${userId}`);
      if (user) {
        user.isOnline = false;
        user.lastSeen = new Date();
        io.emit('user:presence', { userId, isOnline: false, lastSeen: user.lastSeen });
      }
    });
  });
};

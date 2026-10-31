import { Response } from 'express';
import { v4 as uuidv4 } from 'uuid';
import { z } from 'zod';
import { AuthenticatedRequest } from '../middleware/auth';
import { inMemoryDb } from '../database/db';
import { ChatModel, MessageModel } from '../models';
import { Chat, Message, MessageType } from '../types';

export const getChats = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const currentUserId = req.user?.userId;
    if (!currentUserId) {
      res.status(401).json({ success: false, message: 'Unauthorized' });
      return;
    }

    const userChats: Array<{
      chat: Chat;
      otherParticipant?: any;
      unreadCount: number;
      isPinned: boolean;
      isArchived: boolean;
    }> = [];

    for (const chat of inMemoryDb.chats.values()) {
      const participant = chat.participants.find((p) => p.userId === currentUserId);
      if (participant && !participant.isArchived) {
        let otherUser = undefined;
        if (chat.type === 'direct') {
          const otherParticipant = chat.participants.find((p) => p.userId !== currentUserId);
          if (otherParticipant) {
            otherUser = inMemoryDb.users.get(otherParticipant.userId);
          }
        }

        userChats.push({
          chat,
          otherParticipant: otherUser,
          unreadCount: participant.unreadCount,
          isPinned: participant.isPinned,
          isArchived: participant.isArchived,
        });
      }
    }

    // Sort: pinned first, then newest message
    userChats.sort((a, b) => {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      const timeA = a.chat.lastMessage?.createdAt.getTime() || a.chat.updatedAt.getTime();
      const timeB = b.chat.lastMessage?.createdAt.getTime() || b.chat.updatedAt.getTime();
      return timeB - timeA;
    });

    res.status(200).json({ success: true, data: userChats });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const createDirectChatSchema = z.object({
  recipientUserId: z.string().min(1),
});

export const createOrGetDirectChat = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const currentUserId = req.user?.userId;
    if (!currentUserId) {
      res.status(401).json({ success: false, message: 'Unauthorized' });
      return;
    }

    const parseResult = createDirectChatSchema.safeParse(req.body);
    if (!parseResult.success) {
      res.status(400).json({ success: false, errors: parseResult.error.format() });
      return;
    }

    const { recipientUserId } = parseResult.data;
    if (recipientUserId === currentUserId) {
      res.status(400).json({ success: false, message: 'Cannot chat with yourself.' });
      return;
    }

    if (!inMemoryDb.users.has(recipientUserId)) {
      res.status(404).json({ success: false, message: 'Recipient not found.' });
      return;
    }

    // Check if direct chat already exists
    for (const chat of inMemoryDb.chats.values()) {
      if (chat.type === 'direct') {
        const uids = chat.participants.map((p) => p.userId);
        if (uids.includes(currentUserId) && uids.includes(recipientUserId)) {
          const otherUser = inMemoryDb.users.get(recipientUserId);
          res.status(200).json({ success: true, data: { chat, otherParticipant: otherUser } });
          return;
        }
      }
    }

    // Create new direct chat
    const newChatId = uuidv4();
    const newChat: Chat = {
      id: newChatId,
      type: 'direct',
      participants: [
        {
          userId: currentUserId,
          chatId: newChatId,
          role: 'member',
          isPinned: false,
          isArchived: false,
          isMuted: false,
          unreadCount: 0,
          joinedAt: new Date(),
        },
        {
          userId: recipientUserId,
          chatId: newChatId,
          role: 'member',
          isPinned: false,
          isArchived: false,
          isMuted: false,
          unreadCount: 0,
          joinedAt: new Date(),
        },
      ],
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    inMemoryDb.chats.set(newChatId, newChat);
    const otherUser = inMemoryDb.users.get(recipientUserId);

    res.status(201).json({
      success: true,
      message: 'Chat created successfully.',
      data: { chat: newChat, otherParticipant: otherUser },
    });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

/**
 * Cursor-based pagination for messages (20-30 messages per page).
 * Query parameters:
 *  - limit: default 30 (max 50)
 *  - before: ISO date or message ID cursor for older messages
 */
export const getMessages = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const chatId = req.params.chatId as string;
    const currentUserId = req.user?.userId;
    const limit = Math.min(50, Math.max(1, parseInt(req.query.limit as string) || 30));
    const before = req.query.before as string; // Cursor timestamp or ID

    const chat = inMemoryDb.chats.get(chatId);
    if (!chat) {
      res.status(404).json({ success: false, message: 'Chat not found.' });
      return;
    }

    const isMember = chat.participants.some((p) => p.userId === currentUserId);
    if (!isMember) {
      res.status(403).json({ success: false, message: 'You are not a participant of this chat.' });
      return;
    }

    // Mark messages as read for this participant
    const participant = chat.participants.find((p) => p.userId === currentUserId);
    if (participant) {
      participant.unreadCount = 0;
    }

    // Filter messages for this chat
    let chatMessages = Array.from(inMemoryDb.messages.values())
      .filter((m) => m.chatId === chatId);

    // Apply cursor filter if present
    if (before) {
      const beforeDate = new Date(before);
      if (!isNaN(beforeDate.getTime())) {
        chatMessages = chatMessages.filter((m) => m.createdAt.getTime() < beforeDate.getTime());
      }
    }

    // Sort descending to get latest, slice limit, then reverse for chronological display
    chatMessages.sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime());
    const paginated = chatMessages.slice(0, limit);
    paginated.reverse();

    const hasMore = chatMessages.length > limit;
    const nextCursor = paginated.length > 0 ? paginated[0].createdAt.toISOString() : null;

    res.status(200).json({
      success: true,
      data: paginated,
      pagination: {
        limit,
        hasMore,
        nextCursor,
      },
    });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const sendMessageSchema = z.object({
  content: z.string().min(1),
  type: z.enum(['text', 'image', 'video', 'audio', 'voice', 'document', 'location', 'contact']).default('text'),
  replyToId: z.string().optional(),
});

export const sendMessage = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const chatId = req.params.chatId as string;
    const currentUserId = req.user?.userId;
    if (!currentUserId) {
      res.status(401).json({ success: false, message: 'Unauthorized' });
      return;
    }

    const chat = inMemoryDb.chats.get(chatId);
    if (!chat) {
      res.status(404).json({ success: false, message: 'Chat not found.' });
      return;
    }

    const parseResult = sendMessageSchema.safeParse(req.body);
    if (!parseResult.success) {
      res.status(400).json({ success: false, errors: parseResult.error.format() });
      return;
    }

    const { content, type, replyToId } = parseResult.data;

    let replyToMessage: Message | undefined;
    if (replyToId) {
      replyToMessage = inMemoryDb.messages.get(replyToId);
    }

    // Calculate TTL for disappearing messages if set
    let expiresAt: Date | undefined;
    if (chat.disappearingDurationSeconds && chat.disappearingDurationSeconds > 0) {
      expiresAt = new Date(Date.now() + chat.disappearingDurationSeconds * 1000);
    }

    const messageId = uuidv4();
    const newMessage: Message = {
      id: messageId,
      chatId,
      senderId: currentUserId,
      type: type as MessageType,
      content,
      replyToId,
      replyTo: replyToMessage ? { id: replyToMessage.id, content: replyToMessage.content, senderId: replyToMessage.senderId } : undefined,
      isEdited: false,
      isDeletedForEveryone: false,
      status: 'sent',
      reactions: [],
      seenBy: [{ userId: currentUserId, seenAt: new Date() }],
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    inMemoryDb.messages.set(messageId, newMessage);
    chat.lastMessage = newMessage;
    chat.updatedAt = new Date();

    // Increment unread count for other members
    for (const p of chat.participants) {
      if (p.userId !== currentUserId) {
        p.unreadCount += 1;
      }
    }

    res.status(201).json({ success: true, data: newMessage });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const togglePinChat = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const chatId = req.params.chatId as string;
    const currentUserId = req.user?.userId;

    const chat = inMemoryDb.chats.get(chatId);
    if (!chat) {
      res.status(404).json({ success: false, message: 'Chat not found' });
      return;
    }

    const participant = chat.participants.find((p) => p.userId === currentUserId);
    if (!participant) {
      res.status(403).json({ success: false, message: 'Not a member of this chat' });
      return;
    }

    if (!participant.isPinned) {
      let pinnedCount = 0;
      for (const c of inMemoryDb.chats.values()) {
        const p = c.participants.find((part) => part.userId === currentUserId);
        if (p?.isPinned) pinnedCount++;
      }
      if (pinnedCount >= 3) {
        res.status(400).json({ success: false, message: 'You can pin a maximum of 3 chats.' });
        return;
      }
      participant.isPinned = true;
    } else {
      participant.isPinned = false;
    }

    res.status(200).json({ success: true, isPinned: participant.isPinned });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

import mongoose from 'mongoose';
import { v4 as uuidv4 } from 'uuid';
import { config } from '../config';
import { UserModel, ChatModel, MessageModel } from '../models';
import { User, Chat, Message } from '../types';

export const connectDatabase = async (): Promise<void> => {
  try {
    mongoose.set('strictQuery', false);
    await mongoose.connect(config.mongoUri, {
      serverSelectionTimeoutMS: 3000,
    });
    console.log(`[DATABASE] MongoDB Connected Successfully: ${config.mongoUri}`);
    await seedMongoDatabase();
  } catch (error: any) {
    console.warn(`[DATABASE] MongoDB connection warning: ${error.message}`);
    if (config.useInMemoryFallback) {
      console.log('[DATABASE] Running in resilient InMemory + Mongoose Sandbox mode.');
    }
  }
};

// Seed initial users and conversations into MongoDB
async function seedMongoDatabase() {
  try {
    const userCount = await UserModel.countDocuments();
    if (userCount === 0) {
      const u1 = await UserModel.create({
        phoneNumber: '+919876543210',
        countryCode: '+91',
        name: 'Aarav Sharma',
        about: 'Namasty! Baat karo, dil se. 🇮🇳',
        avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=250&q=80',
        isOnline: true,
      });

      const u2 = await UserModel.create({
        phoneNumber: '+919812345678',
        countryCode: '+91',
        name: 'Priya Patel',
        about: 'Sky blue skies & peaceful vibes ☁️',
        avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=250&q=80',
        isOnline: true,
      });

      const u3 = await UserModel.create({
        phoneNumber: '+919999988888',
        countryCode: '+91',
        name: 'Rohan Verma',
        about: 'At work. Reach me on Namasty!',
        avatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=250&q=80',
        isOnline: false,
      });

      // Seed 1-to-1 chat in MongoDB
      const chat = await ChatModel.create({
        type: 'direct',
        participants: [
          { userId: u1._id, role: 'member', isPinned: true, unreadCount: 0 },
          { userId: u2._id, role: 'member', isPinned: false, unreadCount: 0 },
        ],
      });

      const m1 = await MessageModel.create({
        chatId: chat._id,
        senderId: u2._id,
        type: 'text',
        content: 'Namasty Aarav! Have you tested the new sky blue theme?',
        status: 'read',
      });

      chat.lastMessage = m1._id;
      await chat.save();
      console.log('[DATABASE] Seeded demo users and conversations in MongoDB.');
    }
  } catch (err) {
    // Ignore seed errors in non-blocking environments
  }
}

// In-Memory Synchronous Mirror for Instant Resilient Testing
class InMemoryDatabase {
  public users: Map<string, User> = new Map();
  public phoneToUserId: Map<string, string> = new Map();
  public chats: Map<string, Chat> = new Map();
  public messages: Map<string, Message> = new Map();
  public otps: Map<string, { code: string; expiresAt: number }> = new Map();

  constructor() {
    this.seedDemoData();
  }

  public seedDemoData() {
    const demoUser1: User = {
      id: 'u1111111-1111-1111-1111-111111111111',
      phoneNumber: '+919876543210',
      countryCode: '+91',
      name: 'Aarav Sharma',
      about: 'Namasty! Baat karo, dil se. 🇮🇳',
      avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=250&q=80',
      isOnline: true,
      lastSeen: new Date(),
      status: 'active',
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    const demoUser2: User = {
      id: 'u2222222-2222-2222-2222-222222222222',
      phoneNumber: '+919812345678',
      countryCode: '+91',
      name: 'Priya Patel',
      about: 'Sky blue skies & peaceful vibes ☁️',
      avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=250&q=80',
      isOnline: false,
      lastSeen: new Date(Date.now() - 1000 * 60 * 15),
      status: 'active',
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    const demoUser3: User = {
      id: 'u3333333-3333-3333-3333-333333333333',
      phoneNumber: '+919999988888',
      countryCode: '+91',
      name: 'Rohan Verma',
      about: 'At work. Reach me on Namasty!',
      avatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=250&q=80',
      isOnline: true,
      lastSeen: new Date(),
      status: 'active',
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    this.users.set(demoUser1.id, demoUser1);
    this.users.set(demoUser2.id, demoUser2);
    this.users.set(demoUser3.id, demoUser3);
    this.phoneToUserId.set(demoUser1.phoneNumber, demoUser1.id);
    this.phoneToUserId.set(demoUser2.phoneNumber, demoUser2.id);
    this.phoneToUserId.set(demoUser3.phoneNumber, demoUser3.id);

    const chatId1 = 'c1111111-1111-1111-1111-111111111111';
    const msg1: Message = {
      id: uuidv4(),
      chatId: chatId1,
      senderId: demoUser2.id,
      type: 'text',
      content: 'Namasty Aarav! Have you tested the new sky blue theme?',
      isEdited: false,
      isDeletedForEveryone: false,
      status: 'read',
      reactions: [{ userId: demoUser1.id, emoji: '🙏', createdAt: new Date() }],
      seenBy: [
        { userId: demoUser2.id, seenAt: new Date(Date.now() - 1000 * 60 * 10) },
        { userId: demoUser1.id, seenAt: new Date(Date.now() - 1000 * 60 * 9) },
      ],
      createdAt: new Date(Date.now() - 1000 * 60 * 10),
      updatedAt: new Date(Date.now() - 1000 * 60 * 10),
    };

    const msg2: Message = {
      id: uuidv4(),
      chatId: chatId1,
      senderId: demoUser1.id,
      type: 'text',
      content: 'Yes Priya! The sidebar drawer and light blue bubbles feel so fresh.',
      isEdited: false,
      isDeletedForEveryone: false,
      status: 'read',
      reactions: [],
      seenBy: [
        { userId: demoUser1.id, seenAt: new Date(Date.now() - 1000 * 60 * 5) },
        { userId: demoUser2.id, seenAt: new Date(Date.now() - 1000 * 60 * 4) },
      ],
      createdAt: new Date(Date.now() - 1000 * 60 * 5),
      updatedAt: new Date(Date.now() - 1000 * 60 * 5),
    };

    this.messages.set(msg1.id, msg1);
    this.messages.set(msg2.id, msg2);

    const demoChat1: Chat = {
      id: chatId1,
      type: 'direct',
      participants: [
        {
          userId: demoUser1.id,
          chatId: chatId1,
          role: 'member',
          isPinned: true,
          isArchived: false,
          isMuted: false,
          unreadCount: 0,
          joinedAt: new Date(),
        },
        {
          userId: demoUser2.id,
          chatId: chatId1,
          role: 'member',
          isPinned: false,
          isArchived: false,
          isMuted: false,
          unreadCount: 0,
          joinedAt: new Date(),
        },
      ],
      lastMessage: msg2,
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    this.chats.set(chatId1, demoChat1);
  }
}

export const inMemoryDb = new InMemoryDatabase();

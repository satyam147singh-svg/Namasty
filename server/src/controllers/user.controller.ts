import { Response } from 'express';
import { z } from 'zod';
import { AuthenticatedRequest } from '../middleware/auth';
import { inMemoryDb } from '../database/db';
import { User } from '../types';

export const getProfile = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const userId = req.user?.userId;
    if (!userId || !inMemoryDb.users.has(userId)) {
      res.status(404).json({ success: false, message: 'User not found.' });
      return;
    }

    const user = inMemoryDb.users.get(userId)!;
    res.status(200).json({ success: true, data: user });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const updateProfileSchema = z.object({
  name: z.string().min(1).max(100).optional(),
  about: z.string().max(255).optional(),
  avatarUrl: z.string().url().optional(),
});

export const updateProfile = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const userId = req.user?.userId;
    if (!userId || !inMemoryDb.users.has(userId)) {
      res.status(404).json({ success: false, message: 'User not found.' });
      return;
    }

    const parseResult = updateProfileSchema.safeParse(req.body);
    if (!parseResult.success) {
      res.status(400).json({ success: false, errors: parseResult.error.format() });
      return;
    }

    const user = inMemoryDb.users.get(userId)!;
    const { name, about, avatarUrl } = parseResult.data;

    if (name !== undefined) user.name = name;
    if (about !== undefined) user.about = about;
    if (avatarUrl !== undefined) user.avatarUrl = avatarUrl;
    user.updatedAt = new Date();

    inMemoryDb.users.set(userId, user);

    res.status(200).json({ success: true, message: 'Profile updated successfully.', data: user });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const syncContacts = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const { phoneNumbers } = req.body;
    if (!Array.isArray(phoneNumbers)) {
      res.status(400).json({ success: false, message: 'phoneNumbers array is required.' });
      return;
    }

    const matchedUsers: User[] = [];
    const currentUserId = req.user?.userId;

    for (const phone of phoneNumbers) {
      const cleanPhone = phone.replace(/[\s-]/g, '');
      const uid = inMemoryDb.phoneToUserId.get(cleanPhone);
      if (uid && uid !== currentUserId) {
        const u = inMemoryDb.users.get(uid);
        if (u) matchedUsers.push(u);
      }
    }

    res.status(200).json({ success: true, data: matchedUsers });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const getAllUsers = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const currentUserId = req.user?.userId;
    const all = Array.from(inMemoryDb.users.values()).filter((u) => u.id !== currentUserId);
    res.status(200).json({ success: true, data: all });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

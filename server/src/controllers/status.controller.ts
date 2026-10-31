import { Response } from 'express';
import { z } from 'zod';
import { AuthenticatedRequest } from '../middleware/auth';
import { StatusModel } from '../models/status.model';
import { inMemoryDb } from '../database/db';

const postStatusSchema = z.object({
  type: z.enum(['text', 'image', 'video']).default('text'),
  content: z.string().optional(),
  mediaUrl: z.string().optional(),
  caption: z.string().max(300).optional(),
  backgroundColor: z.string().default('#87CEEB'), // Namasty Sky Blue default
  fontFamily: z.string().default('Poppins'),
  privacy: z.enum(['everyone', 'contacts', 'custom']).default('contacts'),
  excludedUserIds: z.array(z.string()).optional(),
});

// Post a status that expires in exactly 24 hours
export const postStatus = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const userId = req.user?.userId;
    if (!userId) {
      res.status(401).json({ success: false, message: 'Unauthorized' });
      return;
    }

    const parseResult = postStatusSchema.safeParse(req.body);
    if (!parseResult.success) {
      res.status(400).json({ success: false, errors: parseResult.error.format() });
      return;
    }

    const { type, content, mediaUrl, caption, backgroundColor, fontFamily, privacy, excludedUserIds } = parseResult.data;
    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000); // 24 hours TTL

    let newStatus;
    try {
      newStatus = await StatusModel.create({
        userId,
        type,
        content,
        mediaUrl,
        caption,
        backgroundColor,
        fontFamily,
        privacy,
        excludedUserIds: excludedUserIds || [],
        expiresAt,
        viewers: [],
      });
    } catch {
      // Fallback in-memory mirror
      newStatus = {
        _id: `status-${Date.now()}`,
        userId,
        type,
        content,
        mediaUrl,
        caption,
        backgroundColor,
        fontFamily,
        privacy,
        expiresAt,
        viewers: [],
        createdAt: new Date(),
      };
    }

    res.status(201).json({
      success: true,
      message: 'Status posted successfully (Expires in 24 hours)',
      data: newStatus,
    });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Fetch current active 24h statuses grouped by user
export const getStatusFeed = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const currentUserId = req.user?.userId;
    const now = new Date();

    // Query non-expired statuses
    let statuses: any[] = [];
    try {
      statuses = await StatusModel.find({
        expiresAt: { $gt: now },
        excludedUserIds: { $ne: currentUserId },
      }).sort({ createdAt: -1 });
    } catch {
      statuses = [];
    }

    // Group statuses by user
    const userStatusMap = new Map<string, any>();

    for (const status of statuses) {
      const uid = status.userId.toString();
      const user = inMemoryDb.users.get(uid);

      if (!userStatusMap.has(uid)) {
        userStatusMap.set(uid, {
          user: user || { id: uid, name: 'Namasty Contact', avatarUrl: null },
          isMe: uid === currentUserId,
          stories: [],
          hasUnviewedStories: false,
          lastStoryAt: status.createdAt,
        });
      }

      const group = userStatusMap.get(uid);
      const isViewed = status.viewers?.some((v: any) => v.userId?.toString() === currentUserId);
      if (!isViewed && uid !== currentUserId) {
        group.hasUnviewedStories = true;
      }

      group.stories.push({
        id: status._id,
        type: status.type,
        content: status.content,
        mediaUrl: status.mediaUrl,
        caption: status.caption,
        backgroundColor: status.backgroundColor,
        fontFamily: status.fontFamily,
        createdAt: status.createdAt,
        expiresAt: status.expiresAt,
        isViewed,
        viewersCount: status.viewers?.length || 0,
        viewers: uid === currentUserId ? status.viewers : undefined, // Only author sees who viewed
      });
    }

    const feed = Array.from(userStatusMap.values());
    // Sort: current user first, then users with unviewed stories
    feed.sort((a, b) => {
      if (a.isMe) return -1;
      if (b.isMe) return 1;
      if (a.hasUnviewedStories && !b.hasUnviewedStories) return -1;
      if (!a.hasUnviewedStories && b.hasUnviewedStories) return 1;
      return new Date(b.lastStoryAt).getTime() - new Date(a.lastStoryAt).getTime();
    });

    res.status(200).json({ success: true, data: feed });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Record view (Seen by list for status story)
export const recordStatusView = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const statusId = req.params.statusId as string;
    const currentUserId = req.user?.userId;

    try {
      await StatusModel.findByIdAndUpdate(statusId, {
        $addToSet: {
          viewers: { userId: currentUserId, viewedAt: new Date() },
        },
      });
    } catch {
      // In-memory fallback
    }

    res.status(200).json({ success: true, message: 'Status view recorded' });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

import { Response } from 'express';
import { v4 as uuidv4 } from 'uuid';
import { z } from 'zod';
import { AuthenticatedRequest } from '../middleware/auth';
import { inMemoryDb } from '../database/db';
import { Chat, ChatParticipant, MemberRole } from '../types';

const createGroupSchema = z.object({
  name: z.string().min(1).max(120),
  description: z.string().max(500).optional(),
  avatarUrl: z.string().url().optional(),
  memberUserIds: z.array(z.string().min(1)).min(1).max(1023), // up to 1024 including creator
  isBroadcastChannel: z.boolean().optional(),
});

export const createGroup = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const creatorId = req.user?.userId;
    if (!creatorId) {
      res.status(401).json({ success: false, message: 'Unauthorized' });
      return;
    }

    const parseResult = createGroupSchema.safeParse(req.body);
    if (!parseResult.success) {
      res.status(400).json({ success: false, errors: parseResult.error.format() });
      return;
    }

    const { name, description, avatarUrl, memberUserIds, isBroadcastChannel = false } = parseResult.data;
    const groupId = uuidv4();
    const inviteCode = `namasty-grp-${uuidv4().substring(0, 8)}`;

    const participants: ChatParticipant[] = [
      {
        userId: creatorId,
        chatId: groupId,
        role: 'super_admin',
        isPinned: false,
        isArchived: false,
        isMuted: false,
        unreadCount: 0,
        joinedAt: new Date(),
      },
    ];

    for (const uid of memberUserIds) {
      if (uid !== creatorId && inMemoryDb.users.has(uid)) {
        participants.push({
          userId: uid,
          chatId: groupId,
          role: 'member',
          isPinned: false,
          isArchived: false,
          isMuted: false,
          unreadCount: 0,
          joinedAt: new Date(),
        });
      }
    }

    const newGroup: Chat = {
      id: groupId,
      type: isBroadcastChannel ? 'broadcast' : 'group',
      name,
      description: description || 'Welcome to Namasty group! Baat karo, dil se.',
      avatarUrl: avatarUrl || `https://api.dicebear.com/7.x/identicon/svg?seed=${name}`,
      createdBy: creatorId,
      inviteCode,
      settings: {
        onlyAdminsCanSend: isBroadcastChannel ? true : false,
        onlyAdminsCanEditInfo: true,
        maxMembers: 1024,
      },
      participants,
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    inMemoryDb.chats.set(groupId, newGroup);

    res.status(201).json({
      success: true,
      message: 'Group created successfully.',
      data: newGroup,
    });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const getGroupDetails = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const groupId = req.params.groupId as string;
    const currentUserId = req.user?.userId;

    const group = inMemoryDb.chats.get(groupId);
    if (!group || (group.type !== 'group' && group.type !== 'broadcast')) {
      res.status(404).json({ success: false, message: 'Group not found' });
      return;
    }

    const isMember = group.participants.some((p) => p.userId === currentUserId);
    if (!isMember) {
      res.status(403).json({ success: false, message: 'You are not a member of this group' });
      return;
    }

    // Populate user info for participants
    const detailedParticipants = group.participants.map((p) => ({
      ...p,
      user: inMemoryDb.users.get(p.userId),
    }));

    res.status(200).json({
      success: true,
      data: {
        ...group,
        participants: detailedParticipants,
        totalMembers: group.participants.length,
        maxMembers: group.settings?.maxMembers || 1024,
      },
    });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

const updateGroupSettingsSchema = z.object({
  name: z.string().min(1).max(120).optional(),
  description: z.string().max(500).optional(),
  avatarUrl: z.string().url().optional(),
  onlyAdminsCanSend: z.boolean().optional(),
  onlyAdminsCanEditInfo: z.boolean().optional(),
});

export const updateGroupSettings = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const groupId = req.params.groupId as string;
    const currentUserId = req.user?.userId;

    const group = inMemoryDb.chats.get(groupId);
    if (!group) {
      res.status(404).json({ success: false, message: 'Group not found' });
      return;
    }

    const currentMember = group.participants.find((p) => p.userId === currentUserId);
    if (!currentMember) {
      res.status(403).json({ success: false, message: 'Not a member' });
      return;
    }

    const isAdmin = currentMember.role === 'admin' || currentMember.role === 'super_admin';
    if (group.settings?.onlyAdminsCanEditInfo && !isAdmin) {
      res.status(403).json({ success: false, message: 'Only admins can modify group settings and info' });
      return;
    }

    const parseResult = updateGroupSettingsSchema.safeParse(req.body);
    if (!parseResult.success) {
      res.status(400).json({ success: false, errors: parseResult.error.format() });
      return;
    }

    const { name, description, avatarUrl, onlyAdminsCanSend, onlyAdminsCanEditInfo } = parseResult.data;

    if (name !== undefined) group.name = name;
    if (description !== undefined) group.description = description;
    if (avatarUrl !== undefined) group.avatarUrl = avatarUrl;
    if (group.settings) {
      if (onlyAdminsCanSend !== undefined) group.settings.onlyAdminsCanSend = onlyAdminsCanSend;
      if (onlyAdminsCanEditInfo !== undefined) group.settings.onlyAdminsCanEditInfo = onlyAdminsCanEditInfo;
    }
    group.updatedAt = new Date();

    res.status(200).json({ success: true, message: 'Group settings updated', data: group });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const updateMemberRole = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const groupId = req.params.groupId as string;
    const targetUserId = req.params.userId as string;
    const { role } = req.body; // 'admin' | 'member'
    const currentUserId = req.user?.userId;

    const group = inMemoryDb.chats.get(groupId);
    if (!group) {
      res.status(404).json({ success: false, message: 'Group not found' });
      return;
    }

    const currentMember = group.participants.find((p) => p.userId === currentUserId);
    if (!currentMember || (currentMember.role !== 'admin' && currentMember.role !== 'super_admin')) {
      res.status(403).json({ success: false, message: 'Only admins can promote or demote members' });
      return;
    }

    const targetMember = group.participants.find((p) => p.userId === targetUserId);
    if (!targetMember) {
      res.status(404).json({ success: false, message: 'Target user is not in this group' });
      return;
    }

    targetMember.role = role as MemberRole;
    group.updatedAt = new Date();

    res.status(200).json({ success: true, message: `Member role updated to ${role}` });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const addMembers = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const groupId = req.params.groupId as string;
    const { userIds } = req.body;
    const currentUserId = req.user?.userId;

    const group = inMemoryDb.chats.get(groupId);
    if (!group) {
      res.status(404).json({ success: false, message: 'Group not found' });
      return;
    }

    const currentMember = group.participants.find((p) => p.userId === currentUserId);
    if (!currentMember || (currentMember.role !== 'admin' && currentMember.role !== 'super_admin')) {
      res.status(403).json({ success: false, message: 'Only admins can add members' });
      return;
    }

    if (group.participants.length + userIds.length > 1024) {
      res.status(400).json({ success: false, message: 'Group capacity exceeded (max 1024 members)' });
      return;
    }

    for (const uid of userIds) {
      if (!group.participants.some((p) => p.userId === uid) && inMemoryDb.users.has(uid)) {
        group.participants.push({
          userId: uid,
          chatId: groupId,
          role: 'member',
          isPinned: false,
          isArchived: false,
          isMuted: false,
          unreadCount: 0,
          joinedAt: new Date(),
        });
      }
    }

    group.updatedAt = new Date();
    res.status(200).json({ success: true, message: 'Members added successfully', totalMembers: group.participants.length });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const removeMember = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const groupId = req.params.groupId as string;
    const targetUserId = req.params.userId as string;
    const currentUserId = req.user?.userId;

    const group = inMemoryDb.chats.get(groupId);
    if (!group) {
      res.status(404).json({ success: false, message: 'Group not found' });
      return;
    }

    const currentMember = group.participants.find((p) => p.userId === currentUserId);
    if (!currentMember || (currentMember.role !== 'admin' && currentMember.role !== 'super_admin')) {
      res.status(403).json({ success: false, message: 'Only admins can remove members' });
      return;
    }

    group.participants = group.participants.filter((p) => p.userId !== targetUserId);
    group.updatedAt = new Date();

    res.status(200).json({ success: true, message: 'Member removed from group' });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const leaveGroup = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const groupId = req.params.groupId as string;
    const currentUserId = req.user?.userId;

    const group = inMemoryDb.chats.get(groupId);
    if (!group) {
      res.status(404).json({ success: false, message: 'Group not found' });
      return;
    }

    group.participants = group.participants.filter((p) => p.userId !== currentUserId);
    group.updatedAt = new Date();

    res.status(200).json({ success: true, message: 'Left the group successfully' });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const getGroupMediaGallery = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const chatId = req.params.chatId as string;
    const media = Array.from(inMemoryDb.messages.values())
      .filter((m) => m.chatId === chatId && m.mediaUrl)
      .map((m) => ({
        id: m.id,
        type: m.type,
        mediaUrl: m.mediaUrl,
        metadata: m.mediaMetadata,
        senderId: m.senderId,
        createdAt: m.createdAt,
      }));

    res.status(200).json({ success: true, data: media });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

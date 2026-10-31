export type UserStatus = 'active' | 'suspended' | 'deleted';
export type ChatType = 'direct' | 'group' | 'broadcast';
export type MemberRole = 'member' | 'admin' | 'super_admin';
export type MessageType = 'text' | 'image' | 'video' | 'audio' | 'voice' | 'document' | 'location' | 'contact';
export type DeliveryStatus = 'sending' | 'sent' | 'delivered' | 'read';

export interface User {
  id: string;
  phoneNumber: string;
  countryCode: string;
  name: string;
  about: string;
  avatarUrl?: string;
  isOnline: boolean;
  lastSeen: Date;
  status: UserStatus;
  createdAt: Date;
  updatedAt: Date;
}

export interface ChatParticipant {
  userId: string;
  chatId: string;
  role: MemberRole;
  isPinned: boolean;
  isArchived: boolean;
  isMuted: boolean;
  unreadCount: number;
  lastReadMessageId?: string;
  joinedAt: Date;
}

export interface GroupSettings {
  onlyAdminsCanSend: boolean;
  onlyAdminsCanEditInfo: boolean;
  maxMembers: number; // up to 1024
}

export interface Chat {
  id: string;
  type: ChatType;
  name?: string;
  description?: string;
  avatarUrl?: string;
  createdBy?: string;
  inviteCode?: string;
  settings?: GroupSettings;
  participants: ChatParticipant[];
  lastMessage?: Message;
  disappearingDurationSeconds?: number;
  createdAt: Date;
  updatedAt: Date;
}

export interface MessageReaction {
  userId: string;
  emoji: string;
  createdAt: Date;
}

export interface MessageSeenRecord {
  userId: string;
  seenAt: Date;
}

export interface MediaMetadata {
  fileName?: string;
  fileSize?: number; // in bytes
  mimeType?: string;
  duration?: number; // seconds for audio/video
  waveform?: number[]; // normalized heights 0..100 for voice notes
  width?: number;
  height?: number;
  latitude?: number;
  longitude?: number;
  address?: string;
  contactName?: string;
  contactPhone?: string;
}

export interface Message {
  id: string;
  chatId: string;
  senderId: string;
  type: MessageType;
  content: string;
  mediaUrl?: string;
  mediaMetadata?: MediaMetadata;
  mentions?: string[]; // user IDs tagged in this message
  replyToId?: string;
  replyTo?: Partial<Message>;
  isEdited: boolean;
  isDeletedForEveryone: boolean;
  status: DeliveryStatus;
  reactions: MessageReaction[];
  seenBy: MessageSeenRecord[];
  createdAt: Date;
  updatedAt: Date;
}

export interface AuthTokenPayload {
  userId: string;
  phoneNumber: string;
}

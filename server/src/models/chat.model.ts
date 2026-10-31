import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IChatParticipant {
  userId: Types.ObjectId | string;
  role: 'member' | 'admin' | 'super_admin';
  isPinned: boolean;
  pinnedAt?: Date;
  isArchived: boolean;
  isMuted: boolean;
  mutedUntil?: Date;
  unreadCount: number;
  lastReadMessageId?: Types.ObjectId | string;
  joinedAt: Date;
}

export interface IChat extends Document {
  type: 'direct' | 'group' | 'broadcast';
  name?: string;
  description?: string;
  avatarUrl?: string;
  createdBy?: Types.ObjectId | string;
  inviteCode?: string;
  settings: {
    onlyAdminsCanSend: boolean;
    onlyAdminsCanEditInfo: boolean;
    maxMembers: number;
  };
  disappearingDurationSeconds: number; // 0 = off, 86400 = 24h, 604800 = 7d
  participants: IChatParticipant[];
  lastMessage?: Types.ObjectId | string;
  createdAt: Date;
  updatedAt: Date;
}

const ChatParticipantSchema = new Schema<IChatParticipant>(
  {
    userId: { type: Schema.Types.Mixed, required: true, index: true },
    role: { type: String, enum: ['member', 'admin', 'super_admin'], default: 'member' },
    isPinned: { type: Boolean, default: false },
    pinnedAt: { type: Date },
    isArchived: { type: Boolean, default: false },
    isMuted: { type: Boolean, default: false },
    mutedUntil: { type: Date },
    unreadCount: { type: Number, default: 0 },
    lastReadMessageId: { type: Schema.Types.Mixed },
    joinedAt: { type: Date, default: Date.now },
  },
  { _id: false }
);

const ChatSchema = new Schema<IChat>(
  {
    type: { type: String, enum: ['direct', 'group', 'broadcast'], default: 'direct', index: true },
    name: { type: String, trim: true },
    description: { type: String, trim: true },
    avatarUrl: { type: String },
    createdBy: { type: Schema.Types.Mixed },
    inviteCode: { type: String, unique: true, sparse: true },
    settings: {
      onlyAdminsCanSend: { type: Boolean, default: false },
      onlyAdminsCanEditInfo: { type: Boolean, default: true },
      maxMembers: { type: Number, default: 1024 },
    },
    disappearingDurationSeconds: { type: Number, default: 0 },
    participants: [ChatParticipantSchema],
    lastMessage: { type: Schema.Types.Mixed, ref: 'Message' },
  },
  {
    timestamps: true,
  }
);

// Indexes
ChatSchema.index({ 'participants.userId': 1 });
ChatSchema.index({ updatedAt: -1 });

export const ChatModel = mongoose.model<IChat>('Chat', ChatSchema);

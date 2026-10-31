import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IMessageReaction {
  userId: Types.ObjectId | string;
  emoji: string;
  createdAt: Date;
}

export interface IMessageSeen {
  userId: Types.ObjectId | string;
  seenAt: Date;
}

export interface IMessage extends Document {
  chatId: Types.ObjectId | string;
  senderId: Types.ObjectId | string;
  type: 'text' | 'image' | 'video' | 'audio' | 'voice' | 'document' | 'location' | 'contact';
  content: string;
  mediaUrl?: string;
  mediaMetadata?: Record<string, any>;
  mentions?: Array<Types.ObjectId | string>;
  replyToId?: Types.ObjectId | string;
  replyTo?: {
    id: string;
    content: string;
    senderId: string;
  };
  isEdited: boolean;
  isDeletedForEveryone: boolean;
  status: 'sending' | 'sent' | 'delivered' | 'read';
  reactions: IMessageReaction[];
  seenBy: IMessageSeen[];
  expiresAt?: Date; // TTL Index for Disappearing Messages
  createdAt: Date;
  updatedAt: Date;
}

const MessageReactionSchema = new Schema<IMessageReaction>(
  {
    userId: { type: Schema.Types.Mixed, required: true },
    emoji: { type: String, required: true },
    createdAt: { type: Date, default: Date.now },
  },
  { _id: false }
);

const MessageSeenSchema = new Schema<IMessageSeen>(
  {
    userId: { type: Schema.Types.Mixed, required: true },
    seenAt: { type: Date, default: Date.now },
  },
  { _id: false }
);

const MessageSchema = new Schema<IMessage>(
  {
    chatId: { type: Schema.Types.Mixed, required: true, index: true },
    senderId: { type: Schema.Types.Mixed, required: true, index: true },
    type: {
      type: String,
      enum: ['text', 'image', 'video', 'audio', 'voice', 'document', 'location', 'contact'],
      default: 'text',
    },
    content: { type: String, required: true },
    mediaUrl: { type: String },
    mediaMetadata: { type: Schema.Types.Mixed },
    mentions: [{ type: Schema.Types.Mixed }],
    replyToId: { type: Schema.Types.Mixed },
    replyTo: {
      id: String,
      content: String,
      senderId: String,
    },
    isEdited: { type: Boolean, default: false },
    isDeletedForEveryone: { type: Boolean, default: false },
    status: {
      type: String,
      enum: ['sending', 'sent', 'delivered', 'read'],
      default: 'sent',
    },
    reactions: [MessageReactionSchema],
    seenBy: [MessageSeenSchema],
    expiresAt: { type: Date }, // Automatically deleted when expiresAt arrives
  },
  {
    timestamps: true,
  }
);

// 1. Compound index for ultra-fast cursor-based pagination
MessageSchema.index({ chatId: 1, createdAt: -1 });

// 2. TTL Index: MongoDB automatically purges documents when current time reaches `expiresAt`
MessageSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });

export const MessageModel = mongoose.model<IMessage>('Message', MessageSchema);

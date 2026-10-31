import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IStatusViewer {
  userId: Types.ObjectId | string;
  viewedAt: Date;
}

export interface IStatus extends Document {
  userId: Types.ObjectId | string;
  type: 'text' | 'image' | 'video';
  content?: string;
  mediaUrl?: string;
  caption?: string;
  backgroundColor?: string;
  fontFamily?: string;
  viewers: IStatusViewer[];
  privacy: 'everyone' | 'contacts' | 'custom';
  excludedUserIds?: Array<Types.ObjectId | string>;
  expiresAt: Date;
  createdAt: Date;
  updatedAt: Date;
}

const StatusViewerSchema = new Schema<IStatusViewer>(
  {
    userId: { type: Schema.Types.Mixed, required: true },
    viewedAt: { type: Date, default: Date.now },
  },
  { _id: false }
);

const StatusSchema = new Schema<IStatus>(
  {
    userId: { type: Schema.Types.Mixed, required: true, index: true },
    type: { type: String, enum: ['text', 'image', 'video'], default: 'text' },
    content: { type: String },
    mediaUrl: { type: String },
    caption: { type: String },
    backgroundColor: { type: String, default: '#2F8FD8' }, // Default Namasty Blue
    fontFamily: { type: String, default: 'Poppins' },
    viewers: [StatusViewerSchema],
    privacy: { type: String, enum: ['everyone', 'contacts', 'custom'], default: 'contacts' },
    excludedUserIds: [{ type: Schema.Types.Mixed }],
    expiresAt: {
      type: Date,
      default: () => new Date(Date.now() + 24 * 60 * 60 * 1000), // Exactly 24 Hours
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

// TTL Index: Auto-delete precisely when 24 hours expire
StatusSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });
StatusSchema.index({ userId: 1, createdAt: -1 });

export const StatusModel = mongoose.model<IStatus>('Status', StatusSchema);

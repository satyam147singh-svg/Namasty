import mongoose, { Schema, Document } from 'mongoose';

export interface IUser extends Document {
  phoneNumber: string;
  countryCode: string;
  name: string;
  about: string;
  avatarUrl?: string;
  isOnline: boolean;
  lastSeen: Date;
  status: 'active' | 'suspended' | 'deleted';
  fcmToken?: string;
  publicIdentityKey?: string;
  registrationId?: number;
  createdAt: Date;
  updatedAt: Date;
}

const UserSchema = new Schema<IUser>(
  {
    phoneNumber: { type: String, required: true, unique: true, index: true },
    countryCode: { type: String, required: true, default: '+91' },
    name: { type: String, required: true, trim: true },
    about: { type: String, default: 'Namasty! Baat karo, dil se.' },
    avatarUrl: { type: String },
    isOnline: { type: Boolean, default: false },
    lastSeen: { type: Date, default: Date.now },
    status: { type: String, enum: ['active', 'suspended', 'deleted'], default: 'active' },
    fcmToken: { type: String },
    publicIdentityKey: { type: String },
    registrationId: { type: Number },
  },
  {
    timestamps: true,
  }
);

export const UserModel = mongoose.model<IUser>('User', UserSchema);

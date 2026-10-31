import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IOneTimePreKey {
  keyId: number;
  publicKey: string;
}

export interface IPreKeyBundle extends Document {
  userId: Types.ObjectId | string;
  registrationId: number;
  identityKey: string; // Public Identity Key
  signedPreKey: {
    keyId: number;
    publicKey: string;
    signature: string;
  };
  oneTimePreKeys: IOneTimePreKey[];
  createdAt: Date;
  updatedAt: Date;
}

const PreKeyBundleSchema = new Schema<IPreKeyBundle>(
  {
    userId: { type: Schema.Types.Mixed, required: true, unique: true, index: true },
    registrationId: { type: Number, required: true },
    identityKey: { type: String, required: true },
    signedPreKey: {
      keyId: { type: Number, required: true },
      publicKey: { type: String, required: true },
      signature: { type: String, required: true },
    },
    oneTimePreKeys: [
      {
        keyId: { type: Number, required: true },
        publicKey: { type: String, required: true },
      },
    ],
  },
  {
    timestamps: true,
  }
);

export const PreKeyBundleModel = mongoose.model<IPreKeyBundle>('PreKeyBundle', PreKeyBundleSchema);

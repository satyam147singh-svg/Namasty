import mongoose, { Schema, Document, Types } from 'mongoose';

export interface ICallLog extends Document {
  callerId: Types.ObjectId | string;
  recipientIds: Array<Types.ObjectId | string>;
  chatId?: Types.ObjectId | string;
  type: 'voice' | 'video';
  isGroup: boolean;
  status: 'missed' | 'completed' | 'rejected' | 'busy';
  durationSeconds: number;
  startedAt: Date;
  endedAt?: Date;
  createdAt: Date;
}

const CallLogSchema = new Schema<ICallLog>(
  {
    callerId: { type: Schema.Types.Mixed, required: true, index: true },
    recipientIds: [{ type: Schema.Types.Mixed, required: true, index: true }],
    chatId: { type: Schema.Types.Mixed },
    type: { type: String, enum: ['voice', 'video'], required: true },
    isGroup: { type: Boolean, default: false },
    status: { type: String, enum: ['missed', 'completed', 'rejected', 'busy'], default: 'completed' },
    durationSeconds: { type: Number, default: 0 },
    startedAt: { type: Date, default: Date.now },
    endedAt: { type: Date },
  },
  {
    timestamps: true,
  }
);

CallLogSchema.index({ callerId: 1, startedAt: -1 });
CallLogSchema.index({ recipientIds: 1, startedAt: -1 });

export const CallLogModel = mongoose.model<ICallLog>('CallLog', CallLogSchema);

import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IReport extends Document {
  reporterId: Types.ObjectId | string;
  reportedUserId?: Types.ObjectId | string;
  reportedChatId?: Types.ObjectId | string;
  reason: string;
  evidenceMessageIds?: Array<Types.ObjectId | string>;
  status: 'pending' | 'reviewed' | 'resolved' | 'dismissed';
  notes?: string;
  createdAt: Date;
  updatedAt: Date;
}

const ReportSchema = new Schema<IReport>(
  {
    reporterId: { type: Schema.Types.Mixed, required: true, index: true },
    reportedUserId: { type: Schema.Types.Mixed, index: true },
    reportedChatId: { type: Schema.Types.Mixed },
    reason: { type: String, required: true },
    evidenceMessageIds: [{ type: Schema.Types.Mixed }],
    status: { type: String, enum: ['pending', 'reviewed', 'resolved', 'dismissed'], default: 'pending', index: true },
    notes: { type: String },
  },
  {
    timestamps: true,
  }
);

export const ReportModel = mongoose.model<IReport>('Report', ReportSchema);

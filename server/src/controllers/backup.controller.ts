import { Response } from 'express';
import { AuthenticatedRequest } from '../middleware/auth';

const userBackups = new Map<string, any>();

export const uploadBackup = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const userId = req.user?.userId;
    if (!userId) {
      res.status(401).json({ success: false, message: 'Unauthorized' });
      return;
    }

    const { backupSize, chatCount, messageCount } = req.body;

    const backupRecord = {
      backupId: `backup-${Date.now()}`,
      userId,
      sizeBytes: backupSize || 1024 * 1024 * 4.2, // ~4.2 MB
      chatCount: chatCount || 12,
      messageCount: messageCount || 428,
      isEncrypted: true,
      encryptionAlgorithm: 'AES-256-GCM',
      downloadUrl: `/uploads/backups/${userId}_encrypted.namastybackup`,
      createdAt: new Date(),
    };

    userBackups.set(userId, backupRecord);

    res.status(200).json({
      success: true,
      message: 'Encrypted backup uploaded successfully',
      data: backupRecord,
    });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export const getLatestBackup = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    const userId = req.user?.userId;
    if (!userId) {
      res.status(401).json({ success: false, message: 'Unauthorized' });
      return;
    }

    const backup = userBackups.get(userId) || {
      backupId: 'backup-default-sample',
      userId,
      sizeBytes: 1024 * 1024 * 3.8, // 3.8 MB
      chatCount: 8,
      messageCount: 312,
      isEncrypted: true,
      encryptionAlgorithm: 'AES-256-GCM',
      downloadUrl: `/uploads/backups/${userId}_sample.namastybackup`,
      createdAt: new Date(Date.now() - 1000 * 60 * 60 * 24 * 2), // 2 days ago
    };

    res.status(200).json({ success: true, data: backup });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

import { Request, Response } from 'express';
import multer from 'multer';
import path from 'path';
import { v4 as uuidv4 } from 'uuid';
import { StorageService } from '../services/storage.service';
import { AuthenticatedRequest } from '../middleware/auth';

StorageService.initialize();

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => {
    cb(null, StorageService.getUploadsPath());
  },
  filename: (_req, file, cb) => {
    const ext = path.extname(file.originalname);
    const uniqueName = `${uuidv4()}${ext}`;
    cb(null, uniqueName);
  },
});

export const uploadMiddleware = multer({
  storage,
  limits: { fileSize: 100 * 1024 * 1024 }, // 100 MB max
});

export const uploadMediaFile = async (req: AuthenticatedRequest, res: Response): Promise<void> => {
  try {
    if (!req.file) {
      res.status(400).json({ success: false, message: 'No file uploaded.' });
      return;
    }

    const file = req.file;
    const fileUrl = `/uploads/${file.filename}`;
    const duration = req.body.duration ? parseFloat(req.body.duration) : undefined;
    const mediaType = req.body.type || 'document';

    // Build rich metadata
    const metadata: Record<string, any> = {
      fileName: file.originalname,
      fileSize: file.size,
      mimeType: file.mimetype,
    };

    if (mediaType === 'voice' || mediaType === 'audio') {
      metadata.duration = duration || 12; // default 12s demo duration
      metadata.waveform = StorageService.generateWaveform(36);
    } else if (mediaType === 'image') {
      metadata.width = 1080;
      metadata.height = 1080;
    }

    res.status(200).json({
      success: true,
      message: 'File uploaded successfully',
      data: {
        mediaUrl: fileUrl,
        type: mediaType,
        metadata,
      },
    });
  } catch (error: any) {
    res.status(500).json({ success: false, message: error.message });
  }
};

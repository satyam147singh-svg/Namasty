import express, { Application, Request, Response } from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import path from 'path';
import authRoutes from './routes/auth.routes';
import userRoutes from './routes/user.routes';
import chatRoutes from './routes/chat.routes';
import mediaRoutes from './routes/media.routes';
import groupRoutes from './routes/group.routes';
import statusRoutes from './routes/status.routes';
import callRoutes from './routes/call.routes';
import e2eeRoutes from './routes/e2ee.routes';
import backupRoutes from './routes/backup.routes';
import adminRoutes from './routes/admin.routes';
import { StorageService } from './services/storage.service';

export const createApp = (): Application => {
  const app = express();

  // Security and utilities
  app.use(helmet({ crossOriginResourcePolicy: { policy: 'cross-origin' } }));
  app.use(cors({ origin: '*', credentials: true }));
  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
  app.use(morgan('dev'));

  // Static uploads directory
  app.use('/uploads', express.static(StorageService.getUploadsPath()));

  // Web Admin Dashboard
  const adminPath = path.join(__dirname, '../public/admin');
  app.use('/admin', express.static(adminPath));

  // Health check endpoint
  app.get('/health', (_req: Request, res: Response) => {
    res.status(200).json({
      status: 'UP',
      app: 'Namasty - Messenger API',
      tagline: 'Namasty! Baat karo, dil se.',
      database: 'MongoDB + Redis',
      adminPortal: '/admin',
      timestamp: new Date().toISOString(),
    });
  });

  // REST API routes
  app.use('/api/v1/auth', authRoutes);
  app.use('/api/v1/users', userRoutes);
  app.use('/api/v1/chats', chatRoutes);
  app.use('/api/v1/media', mediaRoutes);
  app.use('/api/v1/groups', groupRoutes);
  app.use('/api/v1/status', statusRoutes);
  app.use('/api/v1/calls', callRoutes);
  app.use('/api/v1/e2ee', e2eeRoutes);
  app.use('/api/v1/backup', backupRoutes);
  app.use('/api/v1/admin', adminRoutes);

  // 404 handler
  app.use((_req: Request, res: Response) => {
    res.status(404).json({ success: false, message: 'Resource not found' });
  });

  return app;
};

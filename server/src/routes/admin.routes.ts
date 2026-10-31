import { Router } from 'express';
import {
  getDashboardStats,
  getAdminUsers,
  toggleUserBan,
  getModerationReports,
} from '../controllers/admin.controller';

const router = Router();

// In production, add admin authorization middleware (e.g. authenticateAdminJwt)
router.get('/stats', getDashboardStats);
router.get('/users', getAdminUsers);
router.put('/users/:userId/ban', toggleUserBan);
router.get('/reports', getModerationReports);

export default router;

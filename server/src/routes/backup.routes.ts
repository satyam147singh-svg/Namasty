import { Router } from 'express';
import { authenticateJwt } from '../middleware/auth';
import { uploadBackup, getLatestBackup } from '../controllers/backup.controller';

const router = Router();

router.use(authenticateJwt);

router.post('/upload', uploadBackup);
router.get('/latest', getLatestBackup);

export default router;

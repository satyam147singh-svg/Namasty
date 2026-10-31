import { Router } from 'express';
import { authenticateJwt } from '../middleware/auth';
import { uploadMiddleware, uploadMediaFile } from '../controllers/media.controller';

const router = Router();

router.use(authenticateJwt);

router.post('/upload', uploadMiddleware.single('file'), uploadMediaFile);

export default router;

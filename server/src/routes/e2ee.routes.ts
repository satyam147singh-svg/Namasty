import { Router } from 'express';
import { authenticateJwt } from '../middleware/auth';
import { registerKeys, getKeyBundle } from '../controllers/e2ee.controller';

const router = Router();

router.use(authenticateJwt);

router.post('/keys', registerKeys);
router.get('/bundle/:userId', getKeyBundle);

export default router;

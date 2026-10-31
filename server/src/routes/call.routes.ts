import { Router } from 'express';
import { authenticateJwt } from '../middleware/auth';
import { getCallHistory, logCall, getIceServers } from '../controllers/call.controller';

const router = Router();

router.use(authenticateJwt);

router.get('/history', getCallHistory);
router.post('/log', logCall);
router.get('/ice-servers', getIceServers);

export default router;

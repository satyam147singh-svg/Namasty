import { Router } from 'express';
import { authenticateJwt } from '../middleware/auth';
import { postStatus, getStatusFeed, recordStatusView } from '../controllers/status.controller';

const router = Router();

router.use(authenticateJwt);

router.post('/', postStatus);
router.get('/feed', getStatusFeed);
router.post('/:statusId/view', recordStatusView);

export default router;

import { Router } from 'express';
import { authenticateJwt } from '../middleware/auth';
import { getProfile, updateProfile, syncContacts, getAllUsers } from '../controllers/user.controller';

const router = Router();

router.use(authenticateJwt);

router.get('/profile', getProfile);
router.put('/profile', updateProfile);
router.post('/sync-contacts', syncContacts);
router.get('/all', getAllUsers);

export default router;

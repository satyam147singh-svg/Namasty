import { Router } from 'express';
import { authenticateJwt } from '../middleware/auth';
import {
  createGroup,
  getGroupDetails,
  updateGroupSettings,
  updateMemberRole,
  addMembers,
  removeMember,
  leaveGroup,
  getGroupMediaGallery,
} from '../controllers/group.controller';

const router = Router();

router.use(authenticateJwt);

router.post('/', createGroup);
router.get('/:groupId', getGroupDetails);
router.put('/:groupId/settings', updateGroupSettings);
router.put('/:groupId/members/:userId/role', updateMemberRole);
router.post('/:groupId/members', addMembers);
router.delete('/:groupId/members/:userId', removeMember);
router.post('/:groupId/leave', leaveGroup);
router.get('/:chatId/gallery', getGroupMediaGallery);

export default router;

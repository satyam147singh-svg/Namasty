import { Router } from 'express';
import { authenticateJwt } from '../middleware/auth';
import {
  getChats,
  createOrGetDirectChat,
  getMessages,
  sendMessage,
  togglePinChat,
} from '../controllers/chat.controller';

const router = Router();

router.use(authenticateJwt);

router.get('/', getChats);
router.post('/direct', createOrGetDirectChat);
router.get('/:chatId/messages', getMessages);
router.post('/:chatId/messages', sendMessage);
router.post('/:chatId/pin', togglePinChat);

export default router;

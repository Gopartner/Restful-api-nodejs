import express from 'express';
import { askAI, homePage, login, ping } from '../controllers/aiController.js';
import { optionalAuth } from '../middlewares/auth.js';
import { validatePrompt } from '../middlewares/validatePrompt.js';

const router = express.Router();

// Health check
router.get('/ping', ping);

// Home
router.get('/', homePage);

// Login dummy
router.post('/login', login);

// Ask AI
router.post('/ask', optionalAuth, validatePrompt, askAI);

export default router;

import express from 'express';
import { generateVideo, checkStatus, switchService } from '../controllers/videoController';
import { apiLimiter } from '../middleware/rateLimiter';

const router = express.Router();

// Video generation endpoint with rate limiting
router.post('/generate', apiLimiter, generateVideo);

// Status check endpoint
router.get('/status/:id/:service?', checkStatus);

// Service switching endpoint
router.post('/switch-service', switchService);

export default router;
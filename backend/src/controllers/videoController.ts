import { Request, Response } from 'express';
import asyncHandler from 'express-async-handler';
import { VideoService } from '../services/videoService';
import { validatePrompt } from '../validators/promptValidator';
import { config } from '../config/config';

const videoService = new VideoService({
  falAiKey: config.falAiKey,
  replicateApiToken: config.replicateApiToken
});

export const generateVideo = asyncHandler(async (req: Request, res: Response) => {
  const { prompt, service = config.defaultService, referenceImage } = req.body;

  // Validate prompt
  const validationError = validatePrompt(prompt);
  if (validationError) {
    res.status(400).json({ error: validationError });
    return;
  }

  try {
    let result;
    if (service === 'veo3') {
      result = await videoService.generateVideoWithVeo3(prompt, referenceImage);
    } else {
      result = await videoService.generateVideoWithStable(prompt);
    }
    res.json(result);
  } catch (error) {
    console.error('Video generation error:', error);
    res.status(500).json({ error: 'Failed to generate video' });
  }
});

export const checkStatus = asyncHandler(async (req: Request, res: Response) => {
  const { id, service = config.defaultService } = req.params;

  try {
    let status;
    if (service === 'veo3') {
      status = await videoService.checkVeo3Status(id);
    } else {
      status = await videoService.checkStableStatus(id);
    }
    res.json(status);
  } catch (error) {
    console.error('Status check error:', error);
    res.status(500).json({ error: 'Failed to check video status' });
  }
});

// Servis değiştirme endpoint'i
export const switchService = asyncHandler(async (req: Request, res: Response) => {
  const { service } = req.body;

  if (service !== 'veo3' && service !== 'stable') {
    res.status(400).json({ 
      error: 'Invalid service. Use "veo3" or "stable"' 
    });
    return;
  }

  config.defaultService = service;
  res.json({ 
    message: `Switched to ${service} service` 
  });
});
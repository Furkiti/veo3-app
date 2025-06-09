import * as fal from '@fal-ai/serverless-client';
import { config } from '../config/config';

export class Veo3Service {
  private falClient: typeof fal;

  constructor() {
    this.falClient = fal;
    this.falClient.config({
      credentials: process.env.FAL_AI_KEY
    });
  }

  async generateVideo(prompt: string): Promise<any> {
    try {
      const response = await this.falClient.subscribe('fal-ai/veo3', {
        input: {
          prompt: prompt,
          maxDuration: 8,
          resolution: '720p',
          aspectRatio: '16:9'
        }
      });

      return response;
    } catch (error) {
      console.error('Veo3Service error:', error);
      throw error;
    }
  }

  async checkStatus(queueId: string): Promise<any> {
    try {
      const status = await this.falClient.status(queueId);
      return status;
    } catch (error) {
      console.error('Status check error:', error);
      throw error;
    }
  }
} 
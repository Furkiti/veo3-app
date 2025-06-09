import Replicate from 'replicate';
import { config } from '../config/config';

export class StableVideoService {
  private replicate: Replicate;

  constructor() {
    this.replicate = new Replicate({
      auth: process.env.REPLICATE_API_TOKEN,
    });
  }

  async generateVideo(prompt: string): Promise<string> {
    try {
      // Stable Video Diffusion modelini çalıştır
      const output = await this.replicate.run(
        "stability-ai/stable-video-diffusion:3d00263a920172c12c5cd0b4eaa5798cba457416cf44e559d5607e2e288fbb0e",
        {
          input: {
            prompt: prompt,
            video_length: "14_frames_with_svd_xt",
            sizing_strategy: "maintain_aspect_ratio",
            frames_per_second: 6
          }
        }
      );

      if (Array.isArray(output) && output.length > 0) {
        return output[0] as string; // Video URL'i döndür
      } else {
        throw new Error('No video output received');
      }
    } catch (error) {
      console.error('StableVideoService error:', error);
      throw error;
    }
  }

  // Queue status kontrolü için yardımcı fonksiyon
  async checkStatus(predictionId: string): Promise<any> {
    try {
      const prediction = await this.replicate.predictions.get(predictionId);
      return {
        status: prediction.status,
        output: prediction.output,
        error: prediction.error
      };
    } catch (error) {
      console.error('Status check error:', error);
      throw error;
    }
  }
} 
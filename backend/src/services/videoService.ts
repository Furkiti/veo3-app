import * as fal from '@fal-ai/serverless-client';
import Replicate from 'replicate';

interface VideoServiceConfig {
  falAiKey?: string;
  replicateApiToken?: string;
}

interface VideoResponse {
  status: string;
  output?: string;
  error?: string;
  queueId?: string;
}

interface Veo3Response {
  id: string;
  status: string;
  output?: {
    url: string;
  };
  error?: string;
}

interface StablePrediction {
  id: string;
  status: string;
  output?: string[];
  error?: string;
}

export class VideoService {
  private falClient: typeof fal;
  private replicate: Replicate;

  constructor(config: VideoServiceConfig) {
    // Initialize Fal.ai client
    this.falClient = fal;
    if (config.falAiKey) {
      this.falClient.config({
        credentials: config.falAiKey
      });
    }

    // Initialize Replicate client
    this.replicate = new Replicate({
      auth: config.replicateApiToken || ''
    });
  }

  async generateVideoWithVeo3(prompt: string): Promise<VideoResponse> {
    try {
      const response = await this.falClient.subscribe('fal-ai/veo3', {
        input: {
          prompt,
          maxDuration: 8,
          resolution: '720p',
          aspectRatio: '16:9'
        }
      }) as Veo3Response;

      return {
        status: 'PENDING',
        queueId: response.id
      };
    } catch (error) {
      console.error('Veo3 video generation error:', error);
      throw error;
    }
  }

  async generateVideoWithStable(prompt: string): Promise<VideoResponse> {
    try {
      const prediction = await this.replicate.run(
        "stability-ai/stable-video-diffusion",
        {
          input: {
            prompt,
            video_length: "14_frames",
            fps: 6,
            width: 1024,
            height: 576
          }
        }
      ) as StablePrediction;

      return {
        status: prediction.status,
        output: prediction.output?.[0],
        queueId: prediction.id
      };
    } catch (error) {
      console.error('Stable video generation error:', error);
      throw error;
    }
  }

  async checkVeo3Status(queueId: string): Promise<VideoResponse> {
    try {
      const status = await this.falClient.subscribe('fal-ai/veo3/status', {
        input: { queueId }
      }) as Veo3Response;

      return {
        status: status.status,
        output: status.output?.url,
        error: status.error
      };
    } catch (error) {
      console.error('Veo3 status check error:', error);
      throw error;
    }
  }

  async checkStableStatus(predictionId: string): Promise<VideoResponse> {
    try {
      const prediction = await this.replicate.predictions.get(predictionId) as StablePrediction;
      return {
        status: prediction.status,
        output: prediction.output?.[0],
        error: prediction.error
      };
    } catch (error) {
      console.error('Stable status check error:', error);
      throw error;
    }
  }
}
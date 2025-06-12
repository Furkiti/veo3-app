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

interface Veo3BaseInput {
  prompt: string;
  maxDuration: number;
  resolution: string;
  aspectRatio: string;
}

interface Veo3WithImageInput extends Veo3BaseInput {
  reference_image: string;
}

interface StableVideoInput {
  prompt: string;
  video_length: string;
  sizing_strategy: string;
  frames_per_second: number;
  motion_bucket_id: number;
  width?: number;
  height?: number;
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

  async generateVideoWithVeo3(prompt: string, referenceImage?: string): Promise<VideoResponse> {
    try {
      console.log('🎬 Preparing Veo3 request...');
      
      let response: Veo3Response;
      
      if (referenceImage) {
        console.log('📸 Using reference image mode');
        const input: Veo3WithImageInput = {
          prompt,
          maxDuration: 8,
          resolution: '720p',
          aspectRatio: '16:9',
          reference_image: referenceImage
        };

        console.log('📡 Sending request to Fal.ai with reference image...');
        response = await this.falClient.subscribe('fal-ai/veo3', {
          input
        }) as Veo3Response;
      } else {
        console.log('🎨 Using text-only mode');
        const input: Veo3BaseInput = {
          prompt,
          maxDuration: 8,
          resolution: '720p',
          aspectRatio: '16:9'
        };

        console.log('📡 Sending request to Fal.ai without reference image...');
        response = await this.falClient.subscribe('fal-ai/veo3', {
          input
        }) as Veo3Response;
      }

      console.log('✅ Fal.ai response received:', {
        id: response.id,
        status: response.status,
        hasError: !!response.error
      });

      return {
        status: 'PENDING',
        queueId: response.id
      };
    } catch (error: any) {
      console.error('❌ Veo3 video generation error:', error);
      console.error('Error details:', {
        message: error.message,
        stack: error.stack,
        response: error.response?.data
      });
      throw error;
    }
  }

  async generateVideoWithStable(prompt: string): Promise<VideoResponse> {
    try {
      console.log('🎬 Preparing Stable Diffusion request...');
      
      const input: StableVideoInput = {
        prompt,
        video_length: "25_frames_with_svd_xt",
        sizing_strategy: "maintain_aspect_ratio",
        frames_per_second: 6,
        motion_bucket_id: 127
      };

      console.log('📡 Sending request to Stable Diffusion...');
      console.log('Request input:', {
        ...input,
        prompt: input.prompt.substring(0, 100) + '...'
      });

      const prediction = await this.replicate.run(
        "stabilityai/stable-video-diffusion-img2vid-xt-1-1",
        {
          input: {
            prompt,
            video_length: "25_frames_with_svd_xt",
            sizing_strategy: "maintain_aspect_ratio",
            frames_per_second: 6,
            motion_bucket_id: 127
          }
        }
      ) as StablePrediction;

      console.log('✅ Stable Diffusion response received:', {
        id: prediction.id,
        status: prediction.status,
        hasOutput: !!prediction.output,
        hasError: !!prediction.error
      });

      return {
        status: prediction.status,
        output: prediction.output?.[0],
        queueId: prediction.id
      };
    } catch (error: any) {
      console.error('❌ Stable video generation error:', error);
      console.error('Error details:', {
        message: error.message,
        stack: error.stack,
        response: error.response?.data
      });
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
      console.log('🔍 Checking Stable Diffusion status for:', predictionId);
      
      const prediction = await this.replicate.predictions.get(predictionId) as StablePrediction;
      
      console.log('📊 Status check result:', {
        id: predictionId,
        status: prediction.status,
        hasOutput: !!prediction.output,
        hasError: !!prediction.error
      });

      return {
        status: prediction.status,
        output: prediction.output?.[0],
        error: prediction.error
      };
    } catch (error: any) {
      console.error('❌ Stable status check error:', error);
      throw error;
    }
  }
}
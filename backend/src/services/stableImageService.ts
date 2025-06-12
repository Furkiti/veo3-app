import Replicate from 'replicate';

interface StablePrediction {
  id: string;
  status: string;
  output?: string[];
  error?: string;
}

export class StableImageService {
  private replicate: Replicate;

  constructor() {
    this.replicate = new Replicate({
      auth: process.env.REPLICATE_API_TOKEN,
    });
  }

  async generateImage(prompt: string): Promise<string> {
    try {
      console.log('🎨 Creating Stable Diffusion prediction...');
      
      // Prediction oluştur
      const prediction = await this.replicate.predictions.create({
        version: "ac732df83cea7fff18b8472768c88ad041fa750ff7682a21affe81863cbe77e4",
        input: {
          prompt: prompt,
          negative_prompt: "",
          width: 1024,
          height: 1024,
          num_inference_steps: 28,
          guidance_scale: 7.0
        }
      });

      console.log('⏳ Waiting for prediction to complete...');
      
      // Prediction tamamlanana kadar bekle
      const finalPrediction = await this.replicate.predictions.get(prediction.id);

      console.log('✅ Prediction completed:', finalPrediction.status);

      if (finalPrediction.status === 'succeeded' && finalPrediction.output) {
        return finalPrediction.output[0] as string;
      } else {
        throw new Error(`Prediction failed: ${finalPrediction.error || 'Unknown error'}`);
      }
    } catch (error) {
      console.error('StableImageService error:', error);
      throw error;
    }
  }
} 
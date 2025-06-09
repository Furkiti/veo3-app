export interface VideoGenerationRequest {
  prompt: string;
}

export interface VideoGenerationResponse {
  videoUrl: string;
  status: 'completed' | 'failed';
  error?: string;
}

export interface PromptComponents {
  cameraAngle: string;
  setting: string;
  lighting: string;
  action: string;
  turkishDialogue?: string;
  audio?: string;
}

export interface FalApiResponse {
  videoUrl: string;
  status: string;
  error?: string;
}
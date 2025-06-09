import dotenv from 'dotenv';

dotenv.config();

export const config = {
  port: process.env.PORT || 3000,
  falAiKey: process.env.FAL_AI_KEY,
  replicateApiToken: process.env.REPLICATE_API_TOKEN,
  defaultService: 'stable', // 'veo3' or 'stable'
  
  aiRules: {
    promptRules: {
      general: {
        maxLength: 800,
        language: 'English',
        requiresScene: true,
        requiresAction: true
      },
      sceneComponents: {
        required: [
          'camera_angle',
          'lighting',
          'setting',
          'main_action'
        ],
        optional: [
          'time_of_day',
          'weather',
          'mood',
          'background_details'
        ]
      }
    },
    restrictions: {
      forbidden_content: [
        'violence',
        'explicit_content',
        'political_content',
        'copyrighted_characters',
        'brand_names',
        'hate_speech',
        'discrimination'
      ],
      technical_limits: {
        min_words: 10,
        max_words: 200,
        max_characters: 800
      }
    }
  },

  cors: {
    origin: process.env.CORS_ORIGIN || 'http://localhost:5173',
    credentials: true
  }
};
// src/validators/promptValidator.ts
import { config } from '../config/config';

interface PromptRules {
  maxLength: number;
  language: string;
  requiresScene: boolean;
  requiresAction: boolean;
}

export function validatePrompt(prompt: string): string | null {
  if (!prompt) {
    return 'Prompt is required';
  }

  const rules = config.aiRules.promptRules.general as PromptRules;

  // Length check
  if (prompt.length > rules.maxLength) {
    return `Prompt length cannot exceed ${rules.maxLength} characters`;
  }

  // Scene check
  if (rules.requiresScene && !hasSceneDescription(prompt)) {
    return 'Prompt must include a scene description';
  }

  // Action check
  if (rules.requiresAction && !hasAction(prompt)) {
    return 'Prompt must include an action description';
  }

  // Forbidden content check
  const forbiddenContent = config.aiRules.restrictions.forbidden_content;
  for (const content of forbiddenContent) {
    if (prompt.toLowerCase().includes(content.toLowerCase())) {
      return `Prompt contains forbidden content: ${content}`;
    }
  }

  return null;
}

function hasSceneDescription(prompt: string): boolean {
  const sceneKeywords = ['in', 'at', 'on', 'inside', 'outside', 'background'];
  return sceneKeywords.some(keyword => prompt.toLowerCase().includes(keyword));
}

function hasAction(prompt: string): boolean {
  const actionKeywords = ['is', 'are', 'ing', 'moves', 'moving', 'doing'];
  return actionKeywords.some(keyword => prompt.toLowerCase().includes(keyword));
}

// Prompt formatlayıcı yardımcı fonksiyon
export function formatPrompt(params: {
  cameraAngle: string;
  setting: string;
  lighting: string;
  action: string;
  turkishDialogue?: string;
  audio?: string;
}): string {
  const { cameraAngle, setting, lighting, action, turkishDialogue, audio } = params;

  let prompt = `${cameraAngle} frames ${setting}. ${lighting}. ${action}`;

  if (audio) {
    prompt += `. Audio: ${audio}`;
  }

  if (turkishDialogue) {
    prompt += `. Audio: Character speaks in Turkish: "${turkishDialogue}"`;
  }

  return prompt;
}
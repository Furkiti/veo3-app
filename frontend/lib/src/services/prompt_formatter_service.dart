import 'package:flutter/foundation.dart';

class PromptFormatterService {
  static const defaultCameraAngle = 'medium shot, static shot';
  static const defaultLighting = 'natural lighting';
  static const defaultAudio = 'Audio: Ambient background sounds';

  static String formatPrompt(String userPrompt) {
    // Test için sabit bir prompt döndür
    const fixedPrompt = 'medium shot, static shot frames a cow in a green field. The cow is grazing peacefully under natural lighting. Audio: Gentle countryside ambiance with birds chirping';
    
    if (kDebugMode) {
      print('PromptFormatterService - Original prompt: $userPrompt');
      print('PromptFormatterService - Using test prompt: $fixedPrompt');
    }

    return fixedPrompt;
  }

  static bool _containsLighting(String prompt) {
    final lightingKeywords = [
      'lighting',
      'sunlight',
      'moonlight',
      'dark',
      'bright',
      'dim'
    ];
    
    return lightingKeywords.any((keyword) => 
      prompt.toLowerCase().contains(keyword));
  }

  static bool _containsAudio(String prompt) {
    return prompt.toLowerCase().contains('audio:');
  }

  static Map<String, String?> _extractComponents(String prompt) {
    return {
      'camera_angle': _extractCameraAngle(prompt),
      'lighting': _extractLighting(prompt),
      'main_action': prompt,
      'audio': _extractAudio(prompt),
    };
  }

  static String? _extractCameraAngle(String prompt) {
    final cameraTypes = [
      'close-up',
      'medium shot',
      'wide shot',
      'aerial view',
      'tracking shot',
      'dolly zoom',
      'over-the-shoulder'
    ];
    
    final movements = ['static', 'panning', 'tilting', 'following', 'zooming'];
    
    for (final type in cameraTypes) {
      if (prompt.toLowerCase().contains(type)) {
        for (final movement in movements) {
          if (prompt.toLowerCase().contains(movement)) {
            return '$type, $movement shot';
          }
        }
        return '$type, static shot'; // Default to static if no movement specified
      }
    }
    return null;
  }

  static String? _extractLighting(String prompt) {
    final lightingKeywords = [
      'lighting',
      'sunlight',
      'moonlight',
      'dark',
      'bright',
      'dim'
    ];
    
    for (final keyword in lightingKeywords) {
      if (prompt.toLowerCase().contains(keyword)) {
        // Find the sentence containing the lighting description
        final sentences = prompt.split('. ');
        for (final sentence in sentences) {
          if (sentence.toLowerCase().contains(keyword)) {
            return sentence.trim();
          }
        }
      }
    }
    return null;
  }

  static String? _extractAudio(String prompt) {
    if (prompt.toLowerCase().contains('audio:')) {
      final audioIndex = prompt.toLowerCase().indexOf('audio:');
      final audioSection = prompt.substring(audioIndex);
      final endIndex = audioSection.contains('.') 
          ? audioSection.indexOf('.') 
          : audioSection.length;
      return audioSection.substring(0, endIndex).trim();
    }
    return null;
  }

  static bool isValidPrompt(String prompt) {
    try {
      final formattedPrompt = formatPrompt(prompt);
      return formattedPrompt.isNotEmpty &&
          formattedPrompt.contains(defaultCameraAngle) &&
          formattedPrompt.contains('lighting') &&
          formattedPrompt.contains('Audio:');
    } catch (e) {
      if (kDebugMode) {
        print('Prompt validation error: $e');
      }
      return false;
    }
  }
} 
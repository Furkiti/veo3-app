import 'package:flutter/foundation.dart';
import '../services/prompt_formatter_service.dart';
import '../services/api_service.dart';

class VideoGenerationProvider extends ChangeNotifier {
  final ApiService _apiService;
  bool _isLoading = false;
  String? _error;
  String? _videoUrl;

  VideoGenerationProvider(this._apiService);

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get videoUrl => _videoUrl;

  Future<void> generateVideo(String userPrompt) async {
    try {
      if (kDebugMode) {
        print('VideoGenerationProvider - Starting video generation');
        print('VideoGenerationProvider - User prompt: $userPrompt');
      }

      _isLoading = true;
      _error = null;
      notifyListeners();

      // Format the prompt according to Veo3 requirements
      final formattedPrompt = PromptFormatterService.formatPrompt(userPrompt);
      
      if (kDebugMode) {
        print('VideoGenerationProvider - Formatted prompt: $formattedPrompt');
        print('VideoGenerationProvider - Sending to API...');
      }

      // Send the formatted prompt to the API
      final response = await _apiService.generateVideo(formattedPrompt);
      _videoUrl = response['videoUrl'];

      if (kDebugMode) {
        print('VideoGenerationProvider - Received video URL: $_videoUrl');
      }
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('VideoGenerationProvider - Error occurred: $_error');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void reset() {
    _isLoading = false;
    _error = null;
    _videoUrl = null;
    notifyListeners();
  }
} 
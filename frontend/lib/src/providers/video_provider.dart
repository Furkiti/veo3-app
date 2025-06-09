import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

enum VideoGenerationStatus {
  initial,
  generating,
  completed,
  error,
}

class VideoProvider extends ChangeNotifier {
  final ApiService _apiService;
  VideoGenerationStatus _status = VideoGenerationStatus.initial;
  String? _videoUrl;
  String? _error;
  double _progress = 0.0; // Progress değeri (0.0 - 1.0 arası)
  String _statusMessage = ''; // İlerleme durumu mesajı

  VideoProvider({ApiService? apiService})
      : _apiService = apiService ?? ApiService();

  VideoGenerationStatus get status => _status;
  String? get videoUrl => _videoUrl;
  String? get error => _error;
  double get progress => _progress; // Progress getter
  String get statusMessage => _statusMessage; // Status message getter

  void _updateProgress(double value, String message) {
    _progress = value;
    _statusMessage = message;
    notifyListeners();
  }

  Future<void> generateVideo(String prompt) async {
    _status = VideoGenerationStatus.generating;
    _error = null;
    _progress = 0.0;
    _statusMessage = 'Starting video generation...';
    notifyListeners();

    try {
      final response = await _apiService.generateVideo(
        prompt,
        onProgress: (status, progress) {
          if (status == 'IN_PROGRESS') {
            // Her queue update'inde progress'i artır
            _updateProgress(
              progress, 
              'Generating video... ${(progress * 100).toStringAsFixed(0)}%'
            );
          }
        },
      );
      
      _videoUrl = response['videoUrl'] as String;
      _status = VideoGenerationStatus.completed;
      _updateProgress(1.0, 'Video generation completed!');
    } catch (e) {
      _error = e.toString();
      _status = VideoGenerationStatus.error;
      _updateProgress(0.0, 'Error generating video');
    }

    notifyListeners();
  }

  void reset() {
    _status = VideoGenerationStatus.initial;
    _videoUrl = null;
    _error = null;
    _progress = 0.0;
    _statusMessage = '';
    notifyListeners();
  }
} 
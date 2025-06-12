import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

typedef ProgressCallback = void Function(String status, double progress);

class ApiService {
  final Dio _dio;
  final String baseUrl;

  ApiService({String? baseUrl})
      : baseUrl = baseUrl ?? 'http://localhost:4000/api',
        _dio = Dio() {
    _dio.options.baseUrl = baseUrl ?? 'http://localhost:4000/api';
    _dio.options.connectTimeout = const Duration(seconds: 5);
    _dio.options.receiveTimeout = const Duration(minutes: 10);
    _dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Debug modunda request ve response'ları logla
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ));
    }
  }

  Future<Map<String, dynamic>> generateVideo(
    String prompt, {
    String? referenceImage,
    String service = 'stable',
    ProgressCallback? onProgress,
  }) async {
    try {
      if (kDebugMode) {
        print('ApiService - Sending prompt to backend: $prompt');
        print('ApiService - Using service: $service');
        if (referenceImage != null) {
          print('ApiService - Reference image included');
        }
      }

      final response = await _dio.post('/video/generate', data: {
        'prompt': prompt,
        'service': service,
        if (referenceImage != null) 'referenceImage': referenceImage,
      });

      if (kDebugMode) {
        print('ApiService - Backend response: ${response.data}');
      }

      // Queue status'unu kontrol et
      if (response.data['status'] == 'IN_PROGRESS') {
        String queueId = response.data['request_id'];
        return await _pollQueueStatus(queueId, onProgress);
      }

      return response.data;
    } on DioException catch (e) {
      if (kDebugMode) {
        print('ApiService - DioError details:');
        print('Error type: ${e.type}');
        print('Error message: ${e.message}');
        print('Error response: ${e.response?.data}');
        print('Request data: ${e.requestOptions.data}');
      }
      
      final errorMessage = e.response?.data?['error'] ?? e.message ?? 'An error occurred';
      throw Exception(errorMessage);
    } catch (e) {
      if (kDebugMode) {
        print('ApiService - Unexpected error: $e');
      }
      throw Exception('Failed to generate video: $e');
    }
  }

  Future<Map<String, dynamic>> _pollQueueStatus(
    String queueId,
    ProgressCallback? onProgress,
  ) async {
    int totalPolls = 40; // Toplam kontrol sayısı (10 dakika için)
    int currentPoll = 0;
    
    while (true) {
      try {
        final statusResponse = await _dio.get('/video/status/$queueId');
        final status = statusResponse.data['status'];
        
        // İlerlemeyi hesapla (0.0 - 1.0 arası)
        currentPoll++;
        double progress = currentPoll / totalPolls;
        if (progress > 1) progress = 1;
        
        // Progress callback'i çağır
        onProgress?.call(status, progress);

        if (status == 'COMPLETED') {
          return statusResponse.data;
        } else if (status == 'FAILED') {
          throw Exception('Video generation failed');
        }

        // 15 saniye bekle
        await Future.delayed(const Duration(seconds: 15));
        
        if (currentPoll >= totalPolls) {
          throw Exception('Video generation timed out');
        }
      } on DioException catch (e) {
        throw Exception('Failed to check video status: ${e.message}');
      }
    }
  }
} 
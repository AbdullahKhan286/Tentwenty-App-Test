import 'package:dio/dio.dart';
import 'package:tentwenty_app_test/service/dio_service.dart';

import '../model/incoming_movies_model.dart';

class ApiService {
  ApiService._private();
  static final ApiService _instance = ApiService._private();
  static ApiService get instance => _instance;
  static final String _apiKey = '751ea710f73214db9858b7af24ce31d0';

  static final Dio _dio = DioService.instance.dio;

  // Get upcoming movies
  static Future<MovieResponse> getUpcomingMovies({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/upcoming',
        queryParameters: {
          'api_key': _apiKey,
          'page': page,
        },
      );

      return MovieResponse.fromJson(response.data);
    } catch (error) {
      throw _handleError(error);
    }
  }

  // Error handling
  static Exception _handleError(dynamic error) {
    if (error is DioException) {
      // Dio specific errors
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception('Connection timed out');
        case DioExceptionType.badResponse:
          return Exception('Server error: ${error.response?.statusCode}');
        case DioExceptionType.cancel:
          return Exception('Request cancelled');
        default:
          return Exception('Network error occurred');
      }
    }
    return Exception('Something went wrong: $error');
  }
}

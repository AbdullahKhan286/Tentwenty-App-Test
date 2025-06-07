import 'package:dio/dio.dart';
import 'package:tentwenty_app_test/service/dio_service.dart';

import '../model/incoming_movies_model.dart';
import '../model/movie_detail_model.dart';

class ApiService {
  ApiService._private();
  static final ApiService _instance = ApiService._private();
  static ApiService get instance => _instance;

  static final Dio _dio = DioService.instance.dio;
  static const String _apiKey = '751ea710f73214db9858b7af24ce31d0';

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

  // Get movie detail
  static Future<MovieDetail> getMovieDetail(int movieId) async {
    try {
      final response = await _dio.get(
        '/$movieId',
        queryParameters: {
          'api_key': _apiKey,
        },
      );

      return MovieDetail.fromJson(response.data);
    } catch (error) {
      throw _handleError(error);
    }
  }

  // Get movie videos (trailers)
  Future<MovieVideosResponse> getMovieVideos(int movieId) async {
    try {
      final response = await _dio.get(
        '/$movieId/videos',
        queryParameters: {
          'api_key': _apiKey,
        },
      );

      return MovieVideosResponse.fromJson(response.data);
    } catch (error) {
      throw _handleError(error);
    }
  }

  // Get movie images
  Future<MovieImagesResponse> getMovieImages(int movieId) async {
    try {
      final response = await _dio.get(
        '/$movieId/images',
        queryParameters: {
          'api_key': _apiKey,
        },
      );

      return MovieImagesResponse.fromJson(response.data);
    } catch (error) {
      throw _handleError(error);
    }
  }

  // Search movies (for future use)
  Future<MovieResponse> searchMovies(String query, {int page = 1}) async {
    try {
      // Note: This would need a different base URL for search
      // For now, implementing basic search functionality
      final response = await Dio().get(
        'https://api.themoviedb.org/3/search/movie',
        queryParameters: {
          'api_key': _apiKey,
          'query': query,
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
          final statusCode = error.response?.statusCode;
          switch (statusCode) {
            case 404:
              return Exception('Movie not found');
            case 401:
              return Exception('Invalid API key');
            case 429:
              return Exception('Too many requests. Please try again later.');
            default:
              return Exception('Server error: $statusCode');
          }
        case DioExceptionType.cancel:
          return Exception('Request cancelled');
        case DioExceptionType.unknown:
          if (error.error.toString().contains('SocketException')) {
            return Exception('No internet connection');
          }
          return Exception('Network error occurred');
        default:
          return Exception('Network error occurred');
      }
    }
    return Exception('Something went wrong: $error');
  }
}

import 'package:dio/dio.dart';

class DioService {
  DioService._private() {
    _initDio();
  }

  static final DioService _instance = DioService._private();
  static DioService get instance => _instance;

  late Dio dio;

  void _initDio() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.themoviedb.org/3/movie',
        connectTimeout: const Duration(milliseconds: 15000),
        receiveTimeout: const Duration(milliseconds: 15000),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }
}

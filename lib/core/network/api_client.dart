// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'mock_interceptor.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://mock.topup-api.com',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(MockInterceptor());

    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print(obj),
      ),
    );
  }

  Future<dynamic> get(String endpoint) async {
    final response = await _dio.get(endpoint);
    return response.data;
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await _dio.post(endpoint, data: body);
    return response.data;
  }
}

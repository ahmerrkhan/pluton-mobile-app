import 'package:dio/dio.dart';

class NetworkService {
  late Dio _dio;
  
  // Singleton pattern
  static final NetworkService _instance = NetworkService._internal();

  factory NetworkService() {
    return _instance;
  }

  NetworkService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://dummyjson.com/',
        connectTimeout: const Duration(milliseconds: 5000),
        receiveTimeout: const Duration(milliseconds: 3000),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  // GET request
  Future<Response?> getRequest(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      Response response = await _dio.get(endpoint, queryParameters: queryParams);
      return response;
    } on DioException catch (e) {
      print('GET request error: ${e.response?.statusCode} ${e.message}');
      return null;
    }
  }

  // POST request
  Future<Response?> postRequest(String endpoint, Map<String, dynamic> data) async {
    try {
      Response response = await _dio.post(endpoint, data: data);
      return response;
    } on DioException catch (e) {
      print('POST request error: ${e.response?.statusCode} ${e.message}');
      return null;
    }
  }

  // DELETE request
  Future<Response?> deleteRequest(String endpoint, {Map<String, dynamic>? queryParams}) async {
    try {
      Response response = await _dio.delete(endpoint, queryParameters: queryParams);
      return response;
    } on DioException catch (e) {
      print('DELETE request error: ${e.response?.statusCode} ${e.message}');
      return null;
    }
  }
}

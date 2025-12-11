import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:justfind_app/core/constants/api_constants.dart';
import 'package:justfind_app/core/constants/app_constants.dart';
import 'package:justfind_app/core/errors/exceptions.dart';

class DioClient {
  late final Dio _dio;
  final GetStorage _storage = GetStorage();
  
  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl + ApiConstants.apiVersion,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    _dio.interceptors.add(_authInterceptor());
    _dio.interceptors.add(_errorInterceptor());
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }
  
  InterceptorsWrapper _authInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = _storage.read(AppConstants.storageToken);
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    );
  }
  
  InterceptorsWrapper _errorInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) {
        if (error.response != null) {
          final statusCode = error.response!.statusCode;
          String? message;
          try {
            if (error.response!.data is Map<String, dynamic>) {
              message = error.response!.data['message']?.toString();
            }
          } catch (_) {}
          message ??= 'An error occurred';
          
          switch (statusCode) {
            case 401:
              throw UnauthorizedException(message);
            case 404:
              throw NotFoundException(message);
            default:
              throw ServerException(message, statusCode);
          }
        } else {
          throw NetworkException('No internet connection');
        }
      },
    );
  }
  
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<Response> delete(String path) async {
    try {
      return await _dio.delete(path);
    } catch (e) {
      rethrow;
    }
  }
  
  Future<Response> uploadFile(String path, FormData formData) async {
    try {
      return await _dio.post(
        path,
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
    } catch (e) {
      rethrow;
    }
  }
}

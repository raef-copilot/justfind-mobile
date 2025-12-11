class AppException implements Exception {
  final String? message;
  final int? statusCode;
  
  AppException(this.message, [this.statusCode]);
  
  @override
  String toString() => message ?? 'An error occurred';
}

class ServerException extends AppException {
  ServerException(String? message, [int? statusCode]) : super(message, statusCode);
}

class CacheException extends AppException {
  CacheException(String? message) : super(message);
}

class NetworkException extends AppException {
  NetworkException(String? message) : super(message);
}

class UnauthorizedException extends AppException {
  UnauthorizedException(String? message) : super(message, 401);
}

class NotFoundException extends AppException {
  NotFoundException(String? message) : super(message, 404);
}

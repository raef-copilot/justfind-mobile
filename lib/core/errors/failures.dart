abstract class Failure {
  final String message;
  
  Failure(String? rawMessage) : message = _sanitizeMessage(rawMessage);
  
  static String _sanitizeMessage(String? msg) {
    if (msg == null || msg == 'null' || msg.isEmpty) {
      return 'An error occurred';
    }
    return msg;
  }
}

class ServerFailure extends Failure {
  ServerFailure(String? message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String? message) : super(message);
}

class NetworkFailure extends Failure {
  NetworkFailure(String? message) : super(message);
}

class ValidationFailure extends Failure {
  ValidationFailure(String? message) : super(message);
}

class UnauthorizedFailure extends Failure {
  UnauthorizedFailure(String? message) : super(message);
}

class NotFoundFailure extends Failure {
  NotFoundFailure(String? message) : super(message);
}

// Base API Exception
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

// Network Exception
class NetworkException extends ApiException {
  NetworkException(String message) : super(message);
}

// Unauthorized Exception (401)
class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message, 401);
}

// Forbidden Exception (403)
class ForbiddenException extends ApiException {
  ForbiddenException(String message) : super(message, 403);
}

// Not Found Exception (404)
class NotFoundException extends ApiException {
  NotFoundException(String message) : super(message, 404);
}

// Server Exception (500+)
class ServerException extends ApiException {
  ServerException(String message) : super(message, 500);
}

// Validation Exception (400)
class ValidationException extends ApiException {
  final Map<String, dynamic>? errors;

  ValidationException(String message, [this.errors]) : super(message, 400);
}

class AppException implements Exception {
  final String message;
  final String? prefix;

  AppException(this.message, [this.prefix]);

  @override
  String toString() => "$prefix: $message";
}

class AppTimeoutException extends AppException {
  AppTimeoutException(String message) : super(message, "Request Timeout");
}

class FetchDataException extends AppException {
  FetchDataException(String message)
    : super(message, "Error During Communication");
}

class BadRequestException extends AppException {
  BadRequestException(String message) : super(message, "Invalid Request");
}

class UnauthorisedException extends AppException {
  UnauthorisedException(String message) : super(message, "Unauthorised");
}

class NotFoundException extends AppException {
  NotFoundException(String message) : super(message, "Not Found");
}

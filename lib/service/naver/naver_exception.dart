class NaverException implements Exception {
  String? message;
  String? errorCode;

  NaverException({this.message, this.errorCode});

  @override
  String toString() =>
      'NaverException(message: $message, errorCode: $errorCode)';
}

class NaverTokenException extends NaverException {
  NaverTokenException({String? message, String? errorCode})
      : super(message: message, errorCode: errorCode);
}

class NaverServerException extends NaverException {
  NaverServerException({String? message, String? errorCode})
      : super(message: message, errorCode: errorCode);
}

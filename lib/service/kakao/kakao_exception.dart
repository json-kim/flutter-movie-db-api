class KakaoException implements Exception {
  final String? message;
  final String? code;

  KakaoException({this.message, this.code});

  @override
  String toString() => 'KakaoException(message: $message, code: $code)';
}

class KakaoTokenException extends KakaoException {
  KakaoTokenException({String? message, String? code})
      : super(message: message, code: code);
}

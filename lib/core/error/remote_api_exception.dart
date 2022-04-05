import 'package:movie_search/core/error/auth_exception.dart';

/// api 사용시 발생하는 에러
class RemoteApiException extends BaseException {
  RemoteApiException(this.errorCause, this.apiType, this.message)
      : super(message);

  final String? message; // 에러 메시지
  final String apiType; // api 타입
  final ApiErrorCause errorCause; // 에러 원인

  @override
  String toString() {
    return '''
    RemoteApiException: {
      apiType: $apiType,
      errorCause: $errorCause, 
      message: $message
    }
    ''';
  }
}

enum ApiErrorCause {
  INTERNET_DISCONNECTED,
  INVALID_REQUEST,
  ILLEGAL_PARAMS,
}

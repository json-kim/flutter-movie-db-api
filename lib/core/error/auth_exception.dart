import 'package:movie_search/domain/usecase/auth/constants.dart';

class BaseException implements Exception {
  String? message;

  BaseException(this.message);
}

class AuthException extends BaseException {
  LoginMethod loginMethod;

  AuthException(this.loginMethod, {String? message}) : super(message);

  @override
  String toString() =>
      'AuthException(loginMethod: $loginMethod, message: $message)';
}

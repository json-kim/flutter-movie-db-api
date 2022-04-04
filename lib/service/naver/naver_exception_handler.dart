import 'package:dio/dio.dart';

import 'naver_exception.dart';

class NaverExceptionHandler {
  static Future<T> handleApiError<T>(
      Future<T> Function() requestFunction) async {
    try {
      return await requestFunction();
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        final errorCode = e.response?.data['resultcode'];
        final message = e.response?.data['message'];
        throw NaverTokenException(errorCode: errorCode, message: message);
      } else {
        throw e.error;
      }
    } catch (e) {
      rethrow;
    }
  }
}

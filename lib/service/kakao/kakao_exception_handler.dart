import 'package:dio/dio.dart';

import 'kakao_exception.dart';

class KakaoExceptionHandler {
  static Future<T> handleApiError<T>(
      Future<T> Function() requestFunction) async {
    try {
      return await requestFunction();
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        final code = e.response?.data['code'].toString();
        final message = e.response?.data['msg'];

        throw KakaoTokenException(message: message, code: code);
      } else {
        throw e.error;
      }
    } catch (e) {
      rethrow;
    }
  }
}

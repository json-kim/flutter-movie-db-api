import 'package:dio/dio.dart';

import 'functions_constants.dart';

class FunctionsApiFactory {
  static final Dio apiDio = _apiDioInstance();

  static Dio _apiDioInstance() {
    var dio = Dio();
    dio.options.baseUrl =
        ('${FunctionsConstants.scheme}://${FunctionsConstants.api}'); // 기본 url 추가
    dio.interceptors.addAll([
      LogInterceptor(), // 로그 인터셉터 추가
    ]);
    return dio;
  }
}

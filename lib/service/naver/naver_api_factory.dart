import 'package:dio/dio.dart';
import 'package:movie_search/data/data_source/local/token_local_data_source.dart';
import 'package:movie_search/data/data_source/remote/auth/naver_auth_api.dart';

import 'naver_constants.dart';
import 'naver_token_interceptor.dart';

class NaverApiFactory {
  static final authApi = _authApiInstance();
  static final tokenApi = _tokenApiInstance();

  static Dio _authApiInstance() {
    var dio = Dio();
    dio.options.baseUrl =
        '${NaverConstants.scheme}://${NaverConstants.nauth}'; // 베이스 url 추가
    dio.options.contentType = NaverConstants.contentType; // 컨텐트 타입 추가(바디)
    dio.interceptors.addAll([
      LogInterceptor(), // 로그 인터셉터 추가
    ]);
    return dio;
  }

  static Dio _tokenApiInstance() {
    var dio = Dio();
    dio.options.baseUrl =
        '${NaverConstants.scheme}://${NaverConstants.napi}'; // 베이스 url 추가
    dio.options.contentType = NaverConstants.contentType; // 컨텐츠 타입 추가
    dio.interceptors.addAll([
      NaverTokenInterceptor(dio, TokenLocalDataSource.instance,
          NaverAuthApi.instance), // 토큰 인터셉터 추가
      LogInterceptor(), // 로그 인터셉터 추가
    ]);
    return dio;
  }
}

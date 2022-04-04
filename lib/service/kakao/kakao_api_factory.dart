import 'package:dio/dio.dart';
import 'package:movie_search/data/data_source/local/token_local_data_source.dart';
import 'package:movie_search/data/data_source/remote/auth/kakao_auth_api.dart';

import 'kakao_constants.dart';
import 'kakao_token_interceptor.dart';

class KakaoApiFactory {
  static final authApi = _authApiInstance();
  static final tokenApi = _tokenApiInstatnce();

  static Dio _authApiInstance() {
    var dio = Dio();
    dio.options.baseUrl =
        '${KakaoConstants.scheme}://${KakaoConstants.kauth}'; // 베이스 url 추가
    dio.options.contentType = KakaoConstants.contentType; // 콘텐츠 타입 추가
    dio.interceptors.addAll([
      LogInterceptor(), // 로그 인터셉터
    ]);
    return dio;
  }

  static Dio _tokenApiInstatnce() {
    var dio = Dio();
    dio.options.baseUrl =
        '${KakaoConstants.scheme}://${KakaoConstants.kapi}'; // 베이스 url 추가
    dio.options.contentType = KakaoConstants.contentType; // 콘텐츠 타입 추가
    dio.interceptors.addAll([
      TokenInterceptor(
          dio, TokenLocalDataSource.instance, KakaoAuthApi.instance), // 토큰 인터셉터
      LogInterceptor(), // 로그 인터셉터
    ]);
    return dio;
  }
}

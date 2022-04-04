import 'package:dio/dio.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:movie_search/domain/model/auth/token_response.dart';
import 'package:movie_search/service/kakao/kakao_api_factory.dart';
import 'package:movie_search/service/kakao/kakao_constants.dart';

class KakaoAuthApi {
  final Dio _authDio;

  static final KakaoAuthApi instance = KakaoAuthApi();

  KakaoAuthApi({Dio? authDio}) : _authDio = authDio ?? KakaoApiFactory.authApi;

  // 인가 코드 발급
  Future<String> requestAuthorizationCode() async {
    final url = Uri.https('kauth.kakao.com', '/oauth/authorize', {
      KakaoConstants.responseType: KakaoConstants.code,
      KakaoConstants.clientId: 'c566e2fcfa4c8b7497bf3ca6919197ac',
      KakaoConstants.redirectUri:
          'https://us-central1-appfirebase-656ab.cloudfunctions.net/kakaologin',
    });

    final result = await FlutterWebAuth.authenticate(
        url: url.toString(), callbackUrlScheme: 'kakaologincallback');

    final code = Uri.parse(result).queryParameters['code'];
    if (code == null) {
      throw Exception('code 없음');
    }
    return code;
  }

  // 토큰 발급
  Future<TokenResponse> requestToken(String authCode) async {
    final body = {
      KakaoConstants.grantType: KakaoConstants.authorizationCode,
      KakaoConstants.clientId: 'c566e2fcfa4c8b7497bf3ca6919197ac',
      KakaoConstants.redirectUri:
          'https://us-central1-appfirebase-656ab.cloudfunctions.net/kakaologin',
      KakaoConstants.code: authCode,
    };

    final response = await _authDio.post(KakaoConstants.tokenPath, data: body);

    // dio는 디코드된 결과가 나온다.
    final tokenResponse = TokenResponse.fromJson(response.data);

    return tokenResponse;
  }

  // 액세스 토큰 갱신
  Future<TokenResponse> refreshAccessToken(String refreshToken) async {
    final body = {
      KakaoConstants.grantType: 'refresh_token',
      KakaoConstants.clientId: 'c566e2fcfa4c8b7497bf3ca6919197ac',
      KakaoConstants.refreshToken: refreshToken,
    };

    final response = await _authDio.post(KakaoConstants.tokenPath, data: body);

    final tokenResponse = TokenResponse.fromJson(response.data);

    return tokenResponse;
  }
}

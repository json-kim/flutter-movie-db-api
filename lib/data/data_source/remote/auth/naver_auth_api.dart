import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:movie_search/domain/model/auth/token_response.dart';
import 'package:movie_search/service/naver/naver_api_factory.dart';
import 'package:movie_search/service/naver/naver_constants.dart';

import 'naver_auth_result.dart';

class NaverAuthApi {
  final Dio _authDio;

  static final NaverAuthApi instance = NaverAuthApi();

  NaverAuthApi({Dio? authDio}) : _authDio = authDio ?? NaverApiFactory.authApi;

  // 인가 코드 발급
  Future<NaverAuthCodeResult> requestAuthorizationCode() async {
    // 인가코드 요청 uri 생성
    final url = Uri.https(NaverConstants.nauth, NaverConstants.authCodePath, {
      NaverConstants.responseType: 'code',
      NaverConstants.clientId: 'mLNC4eSQZ15UCVwHOSgQ',
      NaverConstants.redirectUri:
          'https://us-central1-appfirebase-656ab.cloudfunctions.net/naverlogin',
      NaverConstants.state: _generateNonce()
    });

    // url 런처를 통해 uri를 실행시키고 로그인 결과가 리디렉트 되면, 해당 값을 앱으로 전달받음
    final result = await FlutterWebAuth.authenticate(
        url: url.toString(), callbackUrlScheme: 'naverlogincallback');

    final code = Uri.parse(result).queryParameters['code'];
    final state = Uri.parse(result).queryParameters['state'];

    if (code == null) {
      throw Exception('code 없음');
    }

    return NaverAuthCodeResult(authCode: code, state: state ?? '');
  }

  // 토큰 발급
  Future<TokenResponse> requestToken(String authCode, String state) async {
    // 요청시 필요한 데이터(body)
    final body = {
      NaverConstants.grantType: NaverConstants.issueGrantType,
      NaverConstants.clientId: 'mLNC4eSQZ15UCVwHOSgQ',
      NaverConstants.clientSecret: 'ffTfhGwF4O',
      NaverConstants.code: authCode,
      NaverConstants.state: state,
    };

    // 토큰 발급 post 요청
    final response = await _authDio.post(NaverConstants.tokenPath, data: body);

    // 토큰 응답 객체로 리턴
    final tokenResponse = TokenResponse.fromJson(response.data);
    return tokenResponse;
  }

  // 액세스 토큰 갱신
  Future<TokenResponse> refreshAccessToken(String refreshToken) async {
    // 요청시 필요한 데이터
    final body = {
      NaverConstants.grantType: NaverConstants.refreshGrantType,
      NaverConstants.clientId: 'mLNC4eSQZ15UCVwHOSgQ',
      NaverConstants.clientSecret: 'ffTfhGwF4O',
      NaverConstants.refreshToken: refreshToken,
    };

    // 토큰 갱신 post 요청
    final response = await _authDio.post(NaverConstants.tokenPath, data: body);

    // 토큰 응답 객체로 리턴
    final tokenResponse = TokenResponse.fromJson(response.data);
    return tokenResponse;
  }

  /// state 문자열 생성 메서드
  /// 네이버 인가코드 발급 요청 파라미터로 포함시키고 리다이렉트 url로 인가코드와 같이 전달받는다.
  /// 토큰 발급 시 state 문자열을 다시 포함시킨다.
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }
}

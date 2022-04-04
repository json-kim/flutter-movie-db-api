import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'apple_auth_result.dart';

class AppleAuthApi {
  final List<AppleIDAuthorizationScopes> _scopes;

  AppleAuthApi({
    List<AppleIDAuthorizationScopes>? scopes,
  }) : _scopes = scopes ??
            [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ];

  // 애플 로그인 (애플 유저 정보, 인가 코드, id 토큰 리턴)
  Future<AppleAuthResult> requestSignInAccount() async {
    // 애플 인증정보를 다시 실행?시키는 어떠한 공격을 방지하기 위해 인증 요청에 32자리 문자열을 포함시킵니다.
    // 우선 애플 로그인에 암호화시킨 32자리 문자열을 포함시키고
    // 파이어베이스로 로그인할 때, 원본 문자열을 포함시키면
    // 애플 로그인의 리턴 결과로 돌아온 문자열이 원본 문자열을 sha256 암호화 시킨 값과 일치해야 합니다.
    final rawNonce = _generateNonce();
    final nonce = _sha256ofString(rawNonce);

    final appleAccount = await SignInWithApple.getAppleIDCredential(
        scopes: _scopes, nonce: nonce);

    return AppleAuthResult(appleAccount, rawNonce);
  }

  // oauth 인증서 발급
  Future<AuthCredential> requestAuthCredential(
      AppleAuthResult authResult) async {
    // 애플로부터 리턴받은 인증 id 토큰으로 OAuth 인증정보 생성
    final authCredential = OAuthProvider("apple.com").credential(
      idToken: authResult.account.identityToken,
      rawNonce: authResult.rawNonce,
    );

    return authCredential;
  }

  Future<void> signOut() async {
    // 애플은 로그아웃을 지원하지 않음
  }

  /// 안전한 램덤 문자열 생성 메서드
  /// 애플 로그인 한 뒤, 다시 로그아웃하고 로그인 하면 동작하지 않는 문제 해결을 위해 랜덤 문자열을 사용해서 로그인에 이용
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// sha256 해시 함수 암호화(단방향)를 통해 입력된 문자열을 암호화된 문자열로 변형
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}

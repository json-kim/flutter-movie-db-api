import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_search/core/error/error_api.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/repository/oauth_api_repository.dart';
import 'package:movie_search/domain/repository/oauth_sdk_repository.dart';

class LogoutUseCase {
  final OAuthSdkRepository _googleAuthRepository;
  final OAuthSdkRepository _appleAuthRepository;
  final OAuthApiRepository _kakaoAuthRepository;
  final OAuthApiRepository _naverAuthRepository;
  final _firebaseAuth = FirebaseAuth.instance;

  LogoutUseCase(
    this._googleAuthRepository,
    this._appleAuthRepository,
    this._kakaoAuthRepository,
    this._naverAuthRepository,
  );

  /// 로그아웃
  /// 로그인 방법별로 분기 나눠서 로그인 처리
  /// IdTokenResult.signInProvider에 로그인 프로바이더 정보가 담겨 있습니다.
  /// IdTokenResult.claim에 커스텀 로그인 프로바이더 정보가 담겨 있습니다.
  /// 구글: google.com
  /// 애플: apple.com
  /// 네이버: custom / claim['provider'] : naver.com
  /// 카카오: custom / claim['provider'] : kakao.com
  Future<Result<void>> call() async {
    return ErrorApi.handleAuthError(() async {
      final idTokenResult = await _firebaseAuth.currentUser?.getIdTokenResult();
      final signInProvider = idTokenResult?.signInProvider;

      if (signInProvider == 'google.com') {
        // 구글
        await _googleAuthRepository.logout();
      } else if (signInProvider == 'apple.com') {
        // 애플
        await _appleAuthRepository.logout();
      } else if (signInProvider == 'custom') {
        // 커스텀 토큰
        final claims = idTokenResult?.claims;
        if (claims != null) {
          final customProvider = claims['provider'];

          if (customProvider == 'kakao.com') {
            // 카카오
            await _kakaoAuthRepository.logout();
          } else if (customProvider == 'naver.com') {
            // 네이버
            await _naverAuthRepository.logout();
          }
        }
      }

      await _firebaseAuth.signOut();
      return const Result.success(null);
    }, '$runtimeType');
  }
}

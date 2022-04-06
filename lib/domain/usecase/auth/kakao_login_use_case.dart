import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_search/core/error/error_api.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/repository/fauth_repository.dart';
import 'package:movie_search/domain/repository/oauth_api_repository.dart';

class KakaoLoginUseCase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final OAuthApiRepository _kakaoAuthRepository;
  final FAuthRepository _fAuthRepository;

  KakaoLoginUseCase(
    this._kakaoAuthRepository,
    this._fAuthRepository,
  );

  Future<Result<void>> call() async {
    return ErrorApi.handleAuthError(() async {
      // 카카오 계정으로 로그인(토큰 발급)
      await _kakaoAuthRepository.login();

      // 카카오 유저정보 가져오기
      final user = await _kakaoAuthRepository.getUserData();

      // 커스텀토큰 발급
      final customToken = await _fAuthRepository.issueCustomToken(user);

      // 파이어베이스 인증
      await _auth.signInWithCustomToken(customToken);

      // 유저정보 업데이트
      final currentUser = _auth.currentUser;
      final idTokenResult = await currentUser?.getIdTokenResult();

      final claims = idTokenResult?.claims;
      if (claims != null) {
        await currentUser?.updateDisplayName(claims['kakaoUserName']);
        await currentUser?.updatePhotoURL(claims['kakaoPhotoUrl']);
      }

      return Result.success(null);
    }, '$runtimeType.call()');
  }
}

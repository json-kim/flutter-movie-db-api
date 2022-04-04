import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_search/domain/repository/fauth_repository.dart';
import 'package:movie_search/domain/repository/oauth_api_repository.dart';

class NaverLoginUseCase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final OAuthApiRepository _naverAuthRepository;
  final FAuthRepository _fAuthRepository;

  NaverLoginUseCase(
    this._naverAuthRepository,
    this._fAuthRepository,
  );

  Future<void> call() async {
    // 네이버 계정으로 로그인(토큰 발급)
    await _naverAuthRepository.login();

    // 네이버 유저정보 가져오기
    final user = await _naverAuthRepository.getUserData();

    // 커스텀 토큰 발급
    final customToken = await _fAuthRepository.issueCustomToken(user);

    // 파이어베이스 인증
    await _auth.signInWithCustomToken(customToken);

    // 유저정보 업데이트
    final currentUser = _auth.currentUser;
    final idTokenResult = await currentUser?.getIdTokenResult();

    final claims = idTokenResult?.claims;
    if (claims != null) {
      await currentUser?.updateDisplayName(claims['naverUserName']);
      await currentUser?.updatePhotoURL(claims['naverPhotoUrl']);
    }
  }
}

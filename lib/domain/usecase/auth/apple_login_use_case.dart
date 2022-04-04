import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_search/domain/repository/oauth_sdk_repository.dart';

class AppleLoginUseCase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final OAuthSdkRepository _appleAuthRepository;

  AppleLoginUseCase(this._appleAuthRepository);

  Future<void> call() async {
    // oauth 인증서 발급
    final authCredential = await _appleAuthRepository.login();

    // 파이어베이스 인증
    await _auth.signInWithCredential(authCredential);

    // 유저정보 업데이트
    final currentUser = _auth.currentUser;
    final userInfo = currentUser?.providerData
        .firstWhere((info) => info.providerId == 'apple.com');

    if (userInfo != null) {
      await currentUser?.updateDisplayName(userInfo.displayName);
      await currentUser?.updatePhotoURL(userInfo.photoURL);
    }
  }
}

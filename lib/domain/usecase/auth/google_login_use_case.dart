import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_search/core/error/error_api.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/repository/oauth_sdk_repository.dart';

class GoogleLoginUseCase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final OAuthSdkRepository _googleAuthRepository;

  GoogleLoginUseCase(this._googleAuthRepository);

  Future<Result<void>> call() async {
    return ErrorApi.handleAuthError(() async {
      // oauth 인증서 발급받기
      final authCredential = await _googleAuthRepository.login();

      // 파이어베이스 인증
      await _auth.signInWithCredential(authCredential);

      // 유저정보 업데이트
      final currentUser = _auth.currentUser;
      final userInfo = currentUser?.providerData
          .firstWhere((info) => info.providerId == 'google.com');

      if (userInfo != null) {
        await currentUser?.updateDisplayName(userInfo.displayName);
        await currentUser?.updatePhotoURL(userInfo.photoURL);
      }

      return Result.success(null);
    }, '$runtimeType.call()');
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_search/core/error/error_api.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/repository/oauth_sdk_repository.dart';

class AppleLoginUseCase {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final OAuthSdkRepository _appleAuthRepository;

  AppleLoginUseCase(this._appleAuthRepository);

  Future<Result<void>> call() async {
    return ErrorApi.handleAuthError(() async {
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

      return Result.success(null);
    }, '$runtimeType.call()');
  }
}

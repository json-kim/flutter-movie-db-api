import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_search/data/data_source/remote/auth/google_auth_api.dart';
import 'package:movie_search/domain/repository/oauth_sdk_repository.dart';

class GoogleAuthRepositoryImpl implements OAuthSdkRepository {
  final GoogleAuthApi _googleAuthApi;
  // final TokenLocalDataSource _tokenLocalDataSource;

  GoogleAuthRepositoryImpl(
    this._googleAuthApi,
    // this._tokenLocalDataSource,
  );

  @override
  Future<AuthCredential> login() async {
    // 구글 계정 로그인 (구글 계정정보 리턴)
    final googleAccount = await _googleAuthApi.requestSignInAccount();

    // 토큰 받아오기
    final token = await _googleAuthApi.requestToken(googleAccount);
    // await setTokenData(token);

    // oauth 인증서 발급
    final authCredential = await _googleAuthApi.requestAuthCredential(token);
    return authCredential;
  }

  // Future<void> setTokenData(TokenResponse token) async {
  //   // 토큰 로컬에 저장(id토큰, access토큰)
  //   await _tokenLocalDataSource.saveIdToken(LoginMethod.google, token.idToken);
  //   await _tokenLocalDataSource.saveAccessToken(
  //       LoginMethod.google, token.accessToken);
  // }

  @override
  Future<void> logout() async {
    await _googleAuthApi.signOut();
  }
}

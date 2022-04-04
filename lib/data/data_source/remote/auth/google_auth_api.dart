import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_search/core/error/auth_exception.dart';
import 'package:movie_search/domain/model/auth/token_response.dart';
import 'package:movie_search/domain/usecase/auth/constants.dart';

class GoogleAuthApi {
  final GoogleSignIn _googleSignIn;
  final List<String>? scopes;

  GoogleAuthApi({
    this.scopes,
    GoogleSignIn? googleSignIn,
  }) : _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: scopes ?? []);

  /// 구글 로그인 (유저 정보 리턴)
  Future<GoogleSignInAccount> requestSignInAccount() async {
    final googleAccount = await _googleSignIn.signIn();

    if (googleAccount == null) {
      throw BaseException('로그인 캔슬');
    }

    return googleAccount;
  }

  /// 토큰 발급 (id토큰, access토큰)
  Future<TokenResponse> requestToken(
      GoogleSignInAccount googleSignInAccount) async {
    final googleAuthentication = await googleSignInAccount.authentication;

    if (googleAuthentication.accessToken == null) {
      throw AuthException(LoginMethod.google, message: '구글 로그인 액세스 토큰 받아오기 실패');
    }

    return TokenResponse(
      idToken: googleAuthentication.idToken,
      accessToken: googleAuthentication.accessToken!,
    );
  }

  /// oauth 인증서 발급
  Future<AuthCredential> requestAuthCredential(TokenResponse token) async {
    return GoogleAuthProvider.credential(
      idToken: token.idToken,
      accessToken: token.accessToken,
    );
  }

  /// 로그아웃 메서드
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}

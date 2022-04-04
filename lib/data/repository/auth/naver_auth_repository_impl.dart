import 'package:movie_search/data/data_source/local/token_local_data_source.dart';
import 'package:movie_search/data/data_source/remote/auth/naver_auth_api.dart';
import 'package:movie_search/data/data_source/remote/auth/naver_user_api.dart';
import 'package:movie_search/domain/model/auth/token_response.dart';
import 'package:movie_search/domain/model/auth/user_response.dart';
import 'package:movie_search/domain/repository/oauth_api_repository.dart';
import 'package:movie_search/domain/usecase/auth/constants.dart';

class NaverAuthRepositoryImpl implements OAuthApiRepository {
  final NaverAuthApi _naverAuthApi;
  final NaverUserApi _naverUserApi;
  final TokenLocalDataSource _tokenLocalDataSource;

  NaverAuthRepositoryImpl(
    this._naverAuthApi,
    this._naverUserApi,
    this._tokenLocalDataSource,
  );

  @override
  Future<UserResponse> getUserData() async {
    final user = await _naverUserApi.getUserData();

    return user;
  }

  @override
  Future<TokenResponse> login() async {
    // 인가코드 발급
    final authResult = await _naverAuthApi.requestAuthorizationCode();

    // 액세스 토큰 발급
    final token =
        await _naverAuthApi.requestToken(authResult.authCode, authResult.state);
    await _setTokenData(token);

    return token;
  }

  Future<void> _setTokenData(TokenResponse token) async {
    // 토큰 로컬에 저장(id토큰, access토큰)
    await _tokenLocalDataSource.saveRefreshToken(
        LoginMethod.naver, token.refreshToken);
    await _tokenLocalDataSource.saveAccessToken(
        LoginMethod.naver, token.accessToken);
  }

  Future<void> _deleteTokenData() async {
    await _tokenLocalDataSource.deleteRefreshToken(LoginMethod.naver);
    await _tokenLocalDataSource.deleteAccessToken(LoginMethod.naver);
  }

  @override
  Future<void> logout() async {
    await _naverUserApi.signOut();
    await _deleteTokenData();
  }
}

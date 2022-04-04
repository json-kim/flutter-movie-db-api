// REST API를 사용하는 oauth 로그인
import 'package:movie_search/domain/model/auth/token_response.dart';
import 'package:movie_search/domain/model/auth/user_response.dart';

abstract class OAuthApiRepository {
  Future<UserResponse> getUserData();
  Future<TokenResponse> login();
  Future<void> logout();
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:movie_search/domain/usecase/auth/constants.dart';

class TokenLocalDataSource {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  TokenLocalDataSource._();

  static final TokenLocalDataSource _instance = TokenLocalDataSource._();
  static TokenLocalDataSource get instance => _instance;

  /// 액세스 토큰 로드(로컬에서)
  Future<String?> loadAccessToken(LoginMethod loginMethod) async {
    final social = loginMethod.name;

    final accessToken =
        await _secureStorage.read(key: social + '.access_token');

    return accessToken;
  }

  /// 리프레시 토큰 로드(로컬에서)
  Future<String?> loadRefreshToken(LoginMethod loginMethod) async {
    final social = loginMethod.name;

    final refreshToken =
        await _secureStorage.read(key: social + '.refresh_token');

    return refreshToken;
  }

  /// 아이디 토큰 로드(로컬에서)
  Future<String?> loadIdToken(LoginMethod loginMethod) async {
    final social = loginMethod.name;

    final idToken = await _secureStorage.read(key: social + '.id_token');

    return idToken;
  }

  /// 액세스 토큰 저장(로컬에)
  Future<void> saveAccessToken(
      LoginMethod loginMethod, String? accessToken) async {
    if (accessToken == null) return;
    final social = loginMethod.name;

    await _secureStorage.write(
        key: social + '.access_token', value: accessToken);
  }

  /// 리프레시 토큰 저장(로컬에)
  Future<void> saveRefreshToken(
      LoginMethod loginMethod, String? refreshToken) async {
    if (refreshToken == null) return;
    final social = loginMethod.name;

    await _secureStorage.write(
        key: social + '.refresh_token', value: refreshToken);
  }

  /// 아이디 토큰 저장(로컬에)
  Future<void> saveIdToken(LoginMethod loginMethod, String? idToken) async {
    if (idToken == null) return;
    final social = loginMethod.name;

    await _secureStorage.write(key: social + '.id_token', value: idToken);
  }

  /// 액세스 토큰 삭제(로컬에서)
  Future<void> deleteAccessToken(LoginMethod loginMethod) async {
    final social = loginMethod.name;

    await _secureStorage.delete(key: social + '.access_token');
  }

  /// 리프레시 토큰 삭제(로컬에서)
  Future<void> deleteRefreshToken(LoginMethod loginMethod) async {
    final social = loginMethod.name;

    await _secureStorage.delete(key: social + '.refresh_token');
  }

  /// 아이디 토큰 삭제(로컬에서)
  Future<void> deleteIdToken(LoginMethod loginMethod) async {
    final social = loginMethod.name;

    await _secureStorage.delete(key: social + '.id_token');
  }
}

import 'package:firebase_auth/firebase_auth.dart';

abstract class OAuthSdkRepository {
  Future<AuthCredential> login();
  Future<void> logout();
}

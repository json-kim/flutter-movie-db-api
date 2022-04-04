import 'package:movie_search/domain/usecase/auth/constants.dart';

class UserResponse {
  String? uid;
  String? email;
  String? userName;
  String? photoUrl;
  LoginMethod loginMethod;

  UserResponse({
    this.uid,
    this.email,
    this.userName,
    this.photoUrl,
    required this.loginMethod,
  });

  @override
  String toString() {
    return 'UserResponse(uid: $uid, email: $email, userName: $userName, photoUrl: $photoUrl, loginMethod: $loginMethod)';
  }
}

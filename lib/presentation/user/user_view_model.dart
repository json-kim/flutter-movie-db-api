import 'package:firebase_auth/firebase_auth.dart';

class UserViewModel {
  final User _user;

  UserViewModel(this._user);

  String? get email => _user.email;
  String? get displayName => _user.displayName;
  String? get phoneNumber => _user.phoneNumber;
  String? get photoUrl => _user.photoURL;
}

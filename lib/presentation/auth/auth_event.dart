import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginWithGoogle() = LoginWithGoogle;
  const factory AuthEvent.loginWithApple() = LoginWithApple;
  const factory AuthEvent.loginWithKakao() = LoginWithKakao;
  const factory AuthEvent.loginWithNaver() = LoginWithNaver;
  const factory AuthEvent.loginWithFacebook() = LoginWithFacebook;
  const factory AuthEvent.loginWithTwitter() = LoginWithTwitter;
  const factory AuthEvent.loginWithYahoo() = LoginWithYahoo;
  const factory AuthEvent.logout() = Logout;
}

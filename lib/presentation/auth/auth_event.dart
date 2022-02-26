import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_event.freezed.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.signInGoogle() = SignInGoogle;
  const factory AuthEvent.signInApple() = SignInApple;
  const factory AuthEvent.signInKakao() = SignInKakao;
  const factory AuthEvent.signInNaver() = SignInNaver;
  const factory AuthEvent.signOut() = SignOut;
}

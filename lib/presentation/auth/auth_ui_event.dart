import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_ui_event.freezed.dart';

@freezed
class AuthUiEvent with _$AuthUiEvent {
  const factory AuthUiEvent.snackBar(String message) = SnackBar;
}

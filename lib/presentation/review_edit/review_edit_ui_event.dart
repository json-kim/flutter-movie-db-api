import 'package:freezed_annotation/freezed_annotation.dart';

part 'review_edit_ui_event.freezed.dart';

@freezed
class ReviewEditUiEvent with _$ReviewEditUiEvent {
  const factory ReviewEditUiEvent.snackBar(String message) = SnackBar;
}

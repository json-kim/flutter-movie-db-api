import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_bookmark_ui_event.freezed.dart';

@freezed
class MovieBookmarkUiEvent with _$MovieBookmarkUiEvent {
  const factory MovieBookmarkUiEvent.snackBar(String message) = SnackBar;
}

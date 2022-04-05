import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_soon_ui_event.freezed.dart';

@freezed
class MovieSoonUiEvent with _$MovieSoonUiEvent {
  const factory MovieSoonUiEvent.snackBar(String message) = SnackBar;
}

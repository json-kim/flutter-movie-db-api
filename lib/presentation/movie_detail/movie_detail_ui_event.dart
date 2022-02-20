import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_detail_ui_event.freezed.dart';

@freezed
class MovieDetailUiEvent with _$MovieDetailUiEvent {
  const factory MovieDetailUiEvent.snackBar(String message) = SnackBar;
}

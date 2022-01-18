import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_detail_event.freezed.dart';

@freezed
class MovieDetailEvent with _$MovieDetailEvent {
  const factory MovieDetailEvent.toggleSave() = ToggleSave;
}

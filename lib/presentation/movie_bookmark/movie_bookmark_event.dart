import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_bookmark_event.freezed.dart';

@freezed
class MovieBookmarkEvent with _$MovieBookmarkEvent {
  const factory MovieBookmarkEvent.load({@Default(1) int page}) =
      _MovieBookmarkEvent;
}

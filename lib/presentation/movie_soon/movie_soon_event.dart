import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/model/movie/movie.dart';

part 'movie_soon_event.freezed.dart';

@freezed
class MovieSoonEvent with _$MovieSoonEvent {
  const factory MovieSoonEvent.load({@Default(0) int page}) = Load;
  const factory MovieSoonEvent.toggleBookmark(Movie movie) = ToggleBookmark;
  const factory MovieSoonEvent.alarm(Movie movie) = Alarm;
}

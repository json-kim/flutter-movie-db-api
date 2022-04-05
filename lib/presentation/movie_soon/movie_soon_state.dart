import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/model/movie/movie.dart';

part 'movie_soon_state.freezed.dart';

@freezed
class MovieSoonState with _$MovieSoonState {
  const factory MovieSoonState({
    @Default(false) bool isLoading,
    @Default(false) bool isToggle,
    @Default(false) bool isBookmarked,
    @Default(false) bool isAlarmed,
    @Default([]) List<Movie> upcomingMovies,
  }) = _MovieSoonState;
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/model/genre/genre.dart';
import 'package:movie_search/domain/model/movie/movie.dart';

part 'movie_home_state.freezed.dart';

@freezed
class MovieHomeState with _$MovieHomeState {
  factory MovieHomeState({
    @Default([]) List<Movie> nowPlayingMovies,
    @Default([]) List<Movie> popularMovies,
    @Default([]) List<Genre> genreList,
    @Default(false) bool isLoading,
    @Default(0) int currentPage,
  }) = _MovieHomeState;
}

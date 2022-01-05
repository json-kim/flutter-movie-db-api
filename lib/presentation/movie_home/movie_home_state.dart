import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/entity/genre/genre.dart';
import 'package:movie_search/domain/entity/movie/movie.dart';

part 'movie_home_state.freezed.dart';

@freezed
class MovieHomeState with _$MovieHomeState {
  factory MovieHomeState(
    List<Movie> nowPlayingMovies,
    List<Movie> popularMovies,
    List<Genre> genreList,
    bool isLoading,
  ) = _MovieHomeState;
}

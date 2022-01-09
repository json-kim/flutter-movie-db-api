import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/entity/movie/movie.dart';

part 'movie_search_state.freezed.dart';

@freezed
class MovieSearchState with _$MovieSearchState {
  const factory MovieSearchState(
    List<Movie> movies,
    bool isLoading,
  ) = _MovieSearchState;
}

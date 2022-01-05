import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/entity/movie/movie.dart';

part 'movie_list_state.freezed.dart';

@freezed
class MovieListState with _$MovieListState {
  factory MovieListState(
    List<Movie> movies,
    bool isLoading,
  ) = _MovieListState;
}

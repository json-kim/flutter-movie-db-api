import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/model/movie/movie.dart';

part 'movie_bookmark_state.freezed.dart';

@freezed
class MovieBookmarkState with _$MovieBookmarkState {
  const factory MovieBookmarkState({
    @Default([]) List<Movie> bookmarkMovies,
    @Default(false) bool isLoading,
  }) = _MovieBookmarkState;
}

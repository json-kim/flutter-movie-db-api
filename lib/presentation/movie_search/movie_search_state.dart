import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/model/movie/movie.dart';

part 'movie_search_state.freezed.dart';

@freezed
class MovieSearchState with _$MovieSearchState {
  const factory MovieSearchState({
    @Default(false) bool isLoading,
  }) = _MovieSearchState;
}

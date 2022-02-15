import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/model/person/person.dart';

part 'movie_bookmark_state.freezed.dart';

@freezed
class MovieBookmarkState with _$MovieBookmarkState {
  const factory MovieBookmarkState({
    @Default([]) List<Movie> bookmarkMovies,
    @Default([]) List<Person> bookmarkPerson,
    @Default(1) moviePage,
    @Default(1) personPage,
    @Default(false) bool isLoading,
  }) = _MovieBookmarkState;
}
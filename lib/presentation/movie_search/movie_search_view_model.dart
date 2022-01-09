import 'package:flutter/material.dart';
import 'package:movie_search/domain/usecase/get_movie_with_query_use_case.dart';
import 'package:movie_search/presentation/movie_search/movie_search_state.dart';

class MovieSearchViewModel with ChangeNotifier {
  final GetMovieWithQueryUseCase _getMovieWithQueryUseCase;
  int _currentPage = 1;

  MovieSearchState state = MovieSearchState([], false);

  MovieSearchViewModel(this._getMovieWithQueryUseCase) {
    initMovieData();
  }

  Future<void> initMovieData() async {}

  Future<void> loadMoviesWithQuery(String query) async {
    final result = await _getMovieWithQueryUseCase(query);

    result.when(
        success: (movies) {
          state = state.copyWith(movies: movies);
        },
        error: (message) {});

    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:movie_search/domain/usecase/get_movie_with_query_use_case.dart';
import 'package:movie_search/presentation/movie_search/movie_search_state.dart';

import 'movie_search_event.dart';

class MovieSearchViewModel with ChangeNotifier {
  final GetMovieWithQueryUseCase _getMovieWithQueryUseCase;
  int _currentPage = 1;
  String _currentQuery = '';

  MovieSearchState _state = MovieSearchState([], false);
  MovieSearchState get state => _state;

  MovieSearchViewModel(this._getMovieWithQueryUseCase);

  void onEvent(MovieSearchEvent event) {
    event.when(
        search: _searchMovies, loadMore: _loadMoreMovies, refresh: _refresh);
  }

  Future<void> initMovieData() async {
    _state = _state.copyWith(movies: [], isLoading: false);
  }

  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) {
      _state = _state.copyWith(movies: []);
    } else {
      final result = await _getMovieWithQueryUseCase(query);

      result.when(
          success: (movies) {
            _state = _state.copyWith(movies: movies);
          },
          error: (message) {});
    }

    notifyListeners();
  }

  Future<void> _loadMoreMovies() async {}

  Future<void> _refresh() async {}
}

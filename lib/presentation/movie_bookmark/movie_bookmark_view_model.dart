import 'package:flutter/material.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/usecase/bookmark/get_bookmark_datas_use_case.dart';
import 'package:movie_search/presentation/movie_bookmark/movie_bookmark_event.dart';
import 'package:movie_search/presentation/movie_bookmark/movie_bookmark_state.dart';

class MovieBookmarkViewModel with ChangeNotifier {
  final GetBookmarkDatasUseCase<Movie> _getBookmarkDatasUseCase;

  MovieBookmarkState _state = MovieBookmarkState();

  MovieBookmarkState get state => _state;

  MovieBookmarkViewModel(this._getBookmarkDatasUseCase);

  void onEvent(MovieBookmarkEvent event) {
    event.when(load: _loadBookmarkMovie);
  }

  Future<void> _loadBookmarkMovie(int page) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _getBookmarkDatasUseCase(page);

    result.when(
      success: (movies) {
        if (page > 1) {
          _state = _state
              .copyWith(bookmarkMovies: [..._state.bookmarkMovies, ...movies]);
        } else {
          _state = _state.copyWith(bookmarkMovies: movies);
        }
      },
      error: (message) {},
    );

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }
}

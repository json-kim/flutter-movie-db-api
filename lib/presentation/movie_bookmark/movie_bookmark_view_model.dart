import 'package:flutter/material.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/usecase/bookmark/get_bookmark_datas_use_case.dart';
import 'package:movie_search/presentation/movie_bookmark/movie_bookmark_state.dart';

class MovieBookmarkViewModel with ChangeNotifier {
  final GetBookmarkDatasUseCase<Movie> _getBookmarkDatasUseCase;

  MovieBookmarkState _state = MovieBookmarkState();

  MovieBookmarkState get state => _state;

  MovieBookmarkViewModel(this._getBookmarkDatasUseCase);

  void onEvent() {}

  Future<void> loadBookmarkMovie() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _getBookmarkDatasUseCase(1);

    result.when(
      success: (movies) {
        _state = _state.copyWith(bookmarkMovies: movies);
      },
      error: (message) {},
    );

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }
}

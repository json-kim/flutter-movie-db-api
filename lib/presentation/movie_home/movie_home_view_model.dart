import 'package:flutter/material.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/domain/usecase/genre/get_genre_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_now_playing_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_popular_use_case.dart';

import 'movie_home_event.dart';
import 'movie_home_state.dart';

class MovieHomeViewModel with ChangeNotifier {
  final GetMovieNowPlayingUseCase _getMovieNowPlayingUseCase;
  final GetGenreUseCase _getGenreUseCase;

  MovieHomeState _state = MovieHomeState();
  MovieHomeState get state => _state;

  MovieHomeViewModel(
    this._getMovieNowPlayingUseCase,
    this._getGenreUseCase,
  ) {
    _loadNowPlayingMovies();
    _loadGenres();
  }

  void onEvent(MovieHomeEvent event) {
    event.when(
      load: () {
        _loadNowPlayingMovies();
        _loadGenres();
      },
      changeCardPage: _changeCardPage,
    );
  }

  void _changeCardPage(int page) {
    _state = _state.copyWith(currentPage: page);
    notifyListeners();
  }

  Future<void> _loadNowPlayingMovies() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result =
        await _getMovieNowPlayingUseCase(const Param.movieNowPlaying());

    result.when(
        success: (page) {
          _state = _state.copyWith(nowPlayingMovies: page.items);
        },
        error: (error) {});

    _state = _state.copyWith(isLoading: false, currentPage: 0);
    notifyListeners();
  }

  Future<void> _loadGenres() async {
    final result = await _getGenreUseCase(const Param.genres());

    result.when(
        success: (genres) {
          _state = _state.copyWith(genreList: genres);
        },
        error: (message) {});

    notifyListeners();
  }
}

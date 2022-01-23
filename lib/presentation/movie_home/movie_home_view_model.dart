import 'package:flutter/material.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/domain/usecase/genre/get_genre_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_now_playing_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_popular_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_with_genre_use_case.dart';

import 'movie_home_state.dart';

class MovieHomeViewModel with ChangeNotifier {
  final GetMoviePopularUseCase _getMoviePopularUseCase;
  final GetMovieNowPlayingUseCase _getMovieNowPlayingUseCase;
  final GetMovieWithGenreUseCase _getMovieWithGenreUseCase;
  final GetGenreUseCase _getGenreUseCase;

  MovieHomeState state = MovieHomeState([], [], [], false);

  MovieHomeViewModel(
    this._getMoviePopularUseCase,
    this._getMovieNowPlayingUseCase,
    this._getMovieWithGenreUseCase,
    this._getGenreUseCase,
  ) {
    loadNowPlayingMovies();
    loadPopularMovies();
    loadGenres();
  }

  Future<void> loadNowPlayingMovies() async {
    final result = await _getMovieNowPlayingUseCase(Param.movieNowPlaying());

    result.when(
        success: (movies) {
          state = state.copyWith(nowPlayingMovies: movies);
        },
        error: (error) {});

    notifyListeners();
  }

  Future<void> loadPopularMovies() async {
    final result = await _getMoviePopularUseCase(Param.moviePopular());

    result.when(
        success: (movies) {
          state = state.copyWith(popularMovies: movies);
        },
        error: (message) {});

    notifyListeners();
  }

  Future<void> loadGenres() async {
    final result = await _getGenreUseCase(const Param.genres());

    result.when(
        success: (genres) {
          state = state.copyWith(genreList: genres);
        },
        error: (message) {});

    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:movie_search/domain/usecase/get_credit_with_movie_use_case.dart';
import 'package:movie_search/domain/usecase/get_movie_detail_use_case.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_state.dart';

class MovieDetailViewModel with ChangeNotifier {
  final GetMovieDetailUseCase _getMovieDetailUseCase;
  final GetCreditWithMovieUseCase _getCreditWithMovieUseCase;
  final int movieId;

  MovieDetailState state = const MovieDetailState.empty();

  MovieDetailViewModel(
      this._getMovieDetailUseCase, this._getCreditWithMovieUseCase,
      {required this.movieId}) {
    loadMovieDetail().then((_) => loadCredits());
  }

  Future<void> loadMovieDetail() async {
    final result = await _getMovieDetailUseCase(movieId);

    result.when(
        success: (movieDetail) {
          state = state.map(state: (state) {
            return state.copyWith(movieDetail: movieDetail);
          }, empty: (empty) {
            return MovieDetailState.state(movieDetail, [], false);
          });
        },
        error: (message) {});

    notifyListeners();
  }

  Future<void> loadCredits() async {
    final result = await _getCreditWithMovieUseCase(movieId);

    result.when(
        success: (credits) {
          state = state.mapOrNull(
              state: (state) => state.copyWith(credits: credits))!;
        },
        error: (message) {});

    notifyListeners();
  }
}

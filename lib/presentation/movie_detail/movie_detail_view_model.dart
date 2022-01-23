import 'package:flutter/material.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_detail_use_case.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_event.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_state.dart';

class MovieDetailViewModel with ChangeNotifier {
  final GetMovieDetailUseCase _getMovieDetailUseCase;
  final int movieId;
  // TODO: 뷰모델 구분, 무비 리스트 뷰모델 제너릭 다형성 이용

  MovieDetailState state = const MovieDetailState.empty();

  MovieDetailViewModel(this._getMovieDetailUseCase, {required this.movieId}) {
    _loadMovieDetail();
  }

  void onEvent(MovieDetailEvent event) {
    event.when(toggleSave: _toggleSave);
  }

  Future<void> _toggleSave() async {}

  Future<void> _loadMovieDetail() async {
    final result = await _getMovieDetailUseCase(Param.movieDetail(movieId));

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
}

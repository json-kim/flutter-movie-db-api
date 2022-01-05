import 'package:flutter/material.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/entity/genre/genre.dart';
import 'package:movie_search/domain/entity/movie/movie.dart';
import 'package:movie_search/domain/usecase/use_case.dart';
import 'package:movie_search/presentation/movie_home/component/movie_list_state.dart';

class SliverMovieListViewModel<T extends UseCase, S> with ChangeNotifier {
  final T _getMovieUseCase;
  S? data;

  MovieListState state = MovieListState([], false);

  SliverMovieListViewModel(this._getMovieUseCase, {this.data}) {
    loadMovies();
  }

  Future<void> loadMovies() async {
    final Result<List<Movie>> result;
    if (data != null && data is Genre) {
      result = await _getMovieUseCase(data);
    } else {
      result = await _getMovieUseCase(1);
    }

    result.when(
        success: (movies) {
          state = state.copyWith(movies: movies);
        },
        error: (message) {});
    notifyListeners();
  }
}

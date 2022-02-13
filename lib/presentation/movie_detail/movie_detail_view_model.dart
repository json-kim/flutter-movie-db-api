import 'package:flutter/material.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/usecase/bookmark/delete_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/find_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/save_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_detail_use_case.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_event.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_state.dart';

class MovieDetailViewModel with ChangeNotifier {
  final GetMovieDetailUseCase _getMovieDetailUseCase;
  final FindBookmarkDataUseCase<Movie> _findBookmarkDataUseCase;
  final SaveBookmarkDataUseCase<Movie> _saveBookmarkDataUseCase;
  final DeleteBookmarkDataUseCase<Movie> _deleteBookmarkDataUseCase;
  final int movieId;

  MovieDetailState _state = const MovieDetailState();

  MovieDetailState get state => _state;

  MovieDetailViewModel(
    this._getMovieDetailUseCase,
    this._findBookmarkDataUseCase,
    this._saveBookmarkDataUseCase,
    this._deleteBookmarkDataUseCase, {
    required this.movieId,
  }) {
    _loadMovieDetail();
    _loadBookmarkData();
  }

  void onEvent(MovieDetailEvent event) {
    event.when(toggleBookmark: _toggleBookmark);
  }

  Future<void> _toggleBookmark() async {
    final movieDetail = _state.movieDetail;

    if (movieDetail == null) {
      return;
    }

    final int resultVal;
    if (!_state.isBookmarked) {
      resultVal = await _saveBookmarkData(Movie.fromMovieDetail(movieDetail));
    } else {
      resultVal = await _deleteBookmarkData(movieId);
    }
    if (resultVal != -1) {
      await _loadBookmarkData();
    }

    notifyListeners();
  }

  Future<int> _saveBookmarkData(Movie movie) async {
    final result = await _saveBookmarkDataUseCase(movie);

    return result.when(
      success: (id) => id,
      error: (message) {
        return -1;
      },
    );
  }

  Future<int> _deleteBookmarkData(int id) async {
    final result = await _deleteBookmarkDataUseCase(id);

    return result.when(
        success: (count) {
          return count;
        },
        error: (message) => -1);
  }

  Future<void> _loadBookmarkData() async {
    final result = await _findBookmarkDataUseCase(movieId);

    final isBookmarked = result.when(success: (movie) {
      return movie.id == movieId;
    }, error: (message) {
      return false;
    });

    _state = _state.copyWith(isBookmarked: isBookmarked);

    notifyListeners();
  }

  Future<void> _loadMovieDetail() async {
    final result = await _getMovieDetailUseCase(Param.movieDetail(movieId));

    result.when(
        success: (movieDetail) {
          _state = _state.copyWith(movieDetail: movieDetail);
        },
        error: (message) {});

    notifyListeners();
  }
}

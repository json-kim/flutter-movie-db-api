import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/usecase/bookmark/delete_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/find_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/save_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_detail_use_case.dart';
import 'package:movie_search/domain/usecase/review/delete_review_use_case.dart';
import 'package:movie_search/domain/usecase/review/get_review_by_movie_use_case.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_event.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_state.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_ui_event.dart';

class MovieDetailViewModel with ChangeNotifier {
  final GetMovieDetailUseCase _getMovieDetailUseCase;
  final FindBookmarkDataUseCase<Movie> _findBookmarkDataUseCase;
  final SaveBookmarkDataUseCase<Movie> _saveBookmarkDataUseCase;
  final DeleteBookmarkDataUseCase<Movie> _deleteBookmarkDataUseCase;
  final GetReviewByMovieUseCase _getReviewByMovieUseCase;
  final DeleteReviewUseCase _deleteReviewUseCase;
  final int movieId;

  MovieDetailState _state = const MovieDetailState();

  MovieDetailState get state => _state;

  final _uiEventController = StreamController<MovieDetailUiEvent>.broadcast();

  Stream<MovieDetailUiEvent> get stream => _uiEventController.stream;

  MovieDetailViewModel(
    this._getMovieDetailUseCase,
    this._findBookmarkDataUseCase,
    this._saveBookmarkDataUseCase,
    this._deleteBookmarkDataUseCase,
    this._getReviewByMovieUseCase,
    this._deleteReviewUseCase, {
    required this.movieId,
  }) {
    _loadMovieDetail();
    _loadBookmarkData();
    _loadReview();
  }

  @override
  void dispose() {
    _uiEventController.close();
    super.dispose();
  }

  void onEvent(MovieDetailEvent event) {
    event.when(
        toggleBookmark: _toggleBookmark,
        loadReview: _loadReview,
        deleteReview: _deleteReview);
  }

  Future<void> _toggleBookmark() async {
    final movieDetail = _state.movieDetail;

    if (movieDetail == null) {
      return;
    }

    final int resultVal;
    if (!_state.isBookmarked) {
      resultVal = await _saveBookmarkData(Movie.fromMovieDetail(movieDetail));
      if (resultVal != -1) {
        _uiEventController
            .add(const MovieDetailUiEvent.snackBar('북마크로 등록되었습니다.'));
        await _loadBookmarkData();
      }
    } else {
      resultVal = await _deleteBookmarkData(movieId);
      if (resultVal != -1) {
        _uiEventController
            .add(const MovieDetailUiEvent.snackBar('북마크에서 삭제되었습니다.'));
        await _loadBookmarkData();
      }
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

  Future<void> _loadReview() async {
    final result = await _getReviewByMovieUseCase(movieId);

    result.when(success: (review) {
      _state = _state.copyWith(review: review);
    }, error: (message) {
      debugPrint(message);
      // 에러 처리
    });

    notifyListeners();
  }

  Future<void> _deleteReview() async {
    final review = _state.review;
    if (review == null) {
      return;
    }

    final result = await _deleteReviewUseCase(review.id);

    result.when(success: (isDelete) {
      if (isDelete) {
        _state = _state.copyWith(review: null);
      }
      _uiEventController.add(const MovieDetailUiEvent.snackBar('삭제 되었습니다.'));
    }, error: (message) {
      debugPrint(message);
      _uiEventController.add(const MovieDetailUiEvent.snackBar('삭제 실패'));
    });

    notifyListeners();
  }
}

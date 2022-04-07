import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/model/review/review.dart';
import 'package:movie_search/domain/usecase/bookmark/get_bookmark_datas_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/util/order_type.dart';
import 'package:movie_search/domain/usecase/review/delete_review_use_case.dart';
import 'package:movie_search/domain/usecase/review/get_reviews_use_case.dart';
import 'package:movie_search/presentation/movie_bookmark/movie_bookmark_event.dart';
import 'package:movie_search/presentation/movie_bookmark/movie_bookmark_state.dart';
import 'package:movie_search/presentation/movie_bookmark/movie_bookmark_ui_event.dart';

class MovieBookmarkViewModel with ChangeNotifier {
  final GetBookmarkDatasUseCase<Movie> _getBookmarkMovieUseCase;
  final GetBookmarkDatasUseCase<Person> _getBookmarkPersonUseCase;
  final GetReviewsUseCase _getReviewsUseCase;
  final DeleteReviewUseCase _deleteReviewUseCase;

  MovieBookmarkState _state = MovieBookmarkState();

  MovieBookmarkState get state => _state;

  MovieBookmarkViewModel(
    this._getBookmarkMovieUseCase,
    this._getBookmarkPersonUseCase,
    this._getReviewsUseCase,
    this._deleteReviewUseCase,
  );

  final _streamController = StreamController<MovieBookmarkUiEvent>.broadcast();
  Stream<MovieBookmarkUiEvent> get uiEventStream => _streamController.stream;

  void onEvent(MovieBookmarkEvent event) {
    event.when(
        load: _load, orderChange: _orderChange, deleteReview: _deleteReview);
  }

  Future<void> _orderChange(OrderType orderType) async {}

  Future<void> _load(bool reset) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    if (reset) {
      _state = _state.copyWith(bookmarkPerson: [], bookmarkMovies: []);
    }
    await _loadBookmarkMovie(_state.moviePage);
    await _loadBookmarkPerson(_state.personPage);
    await _loadReviews(_state.reviewPage);

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }

  Future<void> _loadBookmarkMovie(int page) async {
    final result = await _getBookmarkMovieUseCase(page);

    result.when(
      success: (movies) {
        _state = _state.copyWith(bookmarkMovies: [
          ..._state.bookmarkMovies,
          ...movies,
        ]);
      },
      error: (message) {
        //TODO: 에러 처리
        debugPrint(message);
      },
    );
  }

  Future<void> _loadBookmarkPerson(int page) async {
    final result = await _getBookmarkPersonUseCase(page);

    result.when(success: (person) {
      _state = _state.copyWith(bookmarkPerson: [
        ..._state.bookmarkPerson,
        ...person,
      ]);
    }, error: (message) {
      //TODO: 에러 처리
      debugPrint(message);
    });
  }

  Future<void> _loadReviews(int page) async {
    final result = await _getReviewsUseCase(page);

    result.when(success: (reviews) {
      _state = _state.copyWith(reviews: reviews);
    }, error: (message) {
      debugPrint(message);
    });

    notifyListeners();
  }

  Future<void> _deleteReview(Review review) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _deleteReviewUseCase(review.id);

    result.when(success: (isDelete) {
      _load(true);
      _streamController.add(const MovieBookmarkUiEvent.snackBar('삭제 되었습니다.'));
    }, error: (message) {
      debugPrint(message);
      _streamController.add(const MovieBookmarkUiEvent.snackBar('삭제 실패'));
    });

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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
  ) {
    _moviePagingController.addPageRequestListener(_loadBookmarkMovie);
    _personPagingController.addPageRequestListener(_loadBookmarkPerson);
    _reviewPagingController.addPageRequestListener(_loadReviews);
  }

  final _streamController = StreamController<MovieBookmarkUiEvent>.broadcast();
  Stream<MovieBookmarkUiEvent> get uiEventStream => _streamController.stream;

  final _moviePagingController = PagingController<int, Movie>(firstPageKey: 1);
  PagingController<int, Movie> get moviePagingController =>
      _moviePagingController;

  final _personPagingController =
      PagingController<int, Person>(firstPageKey: 1);
  PagingController<int, Person> get personPagingController =>
      _personPagingController;

  final _reviewPagingController =
      PagingController<int, Review>(firstPageKey: 1);
  PagingController<int, Review> get reviewPagingController =>
      _reviewPagingController;

  void onEvent(MovieBookmarkEvent event) {
    event.when(
        load: _load, orderChange: _orderChange, deleteReview: _deleteReview);
  }

  Future<void> _orderChange(OrderType orderType) async {}

  Future<void> _load() async {
    moviePagingController.refresh();
    personPagingController.refresh();
    reviewPagingController.refresh();
  }

  Future<void> _loadBookmarkMovie(int page) async {
    final result = await _getBookmarkMovieUseCase(page);

    result.when(
      success: (pageResult) {
        final isLastPage = pageResult.isLastPage;
        final newItems = pageResult.items;

        if (isLastPage) {
          _moviePagingController.appendLastPage(newItems);
        } else {
          _moviePagingController.appendPage(newItems, page + 1);
        }
      },
      error: (message) {
        _moviePagingController.error = '가져오기 실패';
      },
    );
  }

  Future<void> _loadBookmarkPerson(int page) async {
    final result = await _getBookmarkPersonUseCase(page);

    result.when(success: (pageResult) {
      final isLastPage = pageResult.isLastPage;
      final newItems = pageResult.items;

      if (isLastPage) {
        _personPagingController.appendLastPage(newItems);
      } else {
        _personPagingController.appendPage(newItems, page + 1);
      }
    }, error: (message) {
      _personPagingController.error = '가져오기 실패';
    });
  }

  Future<void> _loadReviews(int page) async {
    final result = await _getReviewsUseCase(page);

    result.when(success: (pageResult) {
      final isLastPage = pageResult.isLastPage;
      final newItems = pageResult.items;

      if (isLastPage) {
        _reviewPagingController.appendLastPage(newItems);
      } else {
        _reviewPagingController.appendPage(newItems, page + 1);
      }
    }, error: (message) {
      _reviewPagingController.error = '가져오기 실패';
    });

    notifyListeners();
  }

  Future<void> _deleteReview(Review review) async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _deleteReviewUseCase(review.id);

    result.when(success: (isDelete) {
      _reviewPagingController.refresh();
      _streamController.add(const MovieBookmarkUiEvent.snackBar('삭제 되었습니다.'));
    }, error: (message) {
      debugPrint(message);
      _streamController.add(const MovieBookmarkUiEvent.snackBar('삭제 실패'));
    });

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }
}

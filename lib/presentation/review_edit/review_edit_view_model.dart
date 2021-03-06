import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_search/domain/model/movie_detail/movie_detail.dart';
import 'package:movie_search/domain/model/review/review.dart';
import 'package:movie_search/domain/usecase/review/create_review_use_case.dart';
import 'package:movie_search/domain/usecase/review/data/review_builder.dart';
import 'package:movie_search/domain/usecase/review/get_review_by_movie_use_case.dart';
import 'package:movie_search/presentation/review_edit/review_edit_state.dart';
import 'package:movie_search/presentation/review_edit/review_edit_ui_event.dart';
import 'package:share_plus/share_plus.dart';

import 'review_edit_event.dart';

class ReviewEditViewModel with ChangeNotifier {
  final CreateReviewUseCase _createReviewUseCase;
  final GetReviewByMovieUseCase _getReviewByMovieUseCase;

  ReviewEditViewModel(this._createReviewUseCase, this._getReviewByMovieUseCase,
      {MovieDetail? movieDetail, Review? review, bool isEditMode = true}) {
    _state = _state.copyWith(isEditMode: isEditMode);
    if (review != null) {
      _builder.setFromReview(review);
      _state = _state.copyWith(
          rating: review.starRating,
          content: review.content,
          date: review.viewingDate);
    }
    if (movieDetail != null) {
      _builder.setFromMovieDetail(movieDetail);
    }
    notifyListeners();
  }

  final _uiEventController = StreamController<ReviewEditUiEvent>.broadcast();
  Stream<ReviewEditUiEvent> get uiEventStream => _uiEventController.stream;

  final ReviewBuilder _builder = ReviewBuilder();
  String get movieTitle => _builder.movieTitle ?? 'unknown';

  ReviewEditState _state = ReviewEditState(date: DateTime.now());
  ReviewEditState get state => _state;

  @override
  void dispose() {
    _uiEventController.close();
    super.dispose();
  }

  void onEvent(ReviewEditEvent event) {
    event.when(
      setRating: _setRating,
      setDate: _setDate,
      changeMode: _changeMode,
      saveReview: _saveReview,
      shareReview: _shareReview,
    );
  }

  void _shareReview() {
    Share.share('${_builder.movieTitle!}\n${state.content}');
  }

  void _changeMode(bool isEditMode) {
    _state = _state.copyWith(isEditMode: isEditMode);
    notifyListeners();
  }

  void _setRating(double rating) {
    _state = _state.copyWith(rating: rating);
    notifyListeners();
  }

  void _setDate(DateTime date) {
    _state = _state.copyWith(date: date);
    notifyListeners();
  }

  Future<void> _saveReview(String content) async {
    if (content.isEmpty) {
      _uiEventController.add(const ReviewEditUiEvent.snackBar('???????????? ??????????????????'));
    }

    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    _builder.viewingDate = _state.date;
    _builder.content = content;
    _builder.starRating = _state.rating;

    final Review review = _builder.build();

    final result = await _createReviewUseCase(review);

    result.when(success: (createResult) async {
      await _loadReview();
      _state = _state.copyWith(isEditMode: false);
      _uiEventController.add(const ReviewEditUiEvent.snackBar('?????????????????????.'));
    }, error: (message) {
      //TODO: ?????? ?????????
    });

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }

  Future<void> _loadReview() async {
    final result = await _getReviewByMovieUseCase(_builder.movieId!);

    result.when(success: (review) {
      _state = _state.copyWith(
        date: review.viewingDate,
        content: review.content,
        rating: review.starRating,
      );
    }, error: (message) {
      debugPrint(message);
    });
  }
}

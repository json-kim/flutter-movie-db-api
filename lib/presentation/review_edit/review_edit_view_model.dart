import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_search/domain/model/movie_detail/movie_detail.dart';
import 'package:movie_search/domain/model/review/review.dart';
import 'package:movie_search/domain/usecase/review/create_review_use_case.dart';
import 'package:movie_search/domain/usecase/review/data/review_builder.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_event.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_view_model.dart';
import 'package:movie_search/presentation/review_edit/review_edit_state.dart';
import 'package:movie_search/presentation/review_edit/review_edit_ui_event.dart';

import 'review_edit_event.dart';

class ReviewEditViewModel with ChangeNotifier {
  final CreateReviewUseCase _createReviewUseCase;

  final MovieDetailViewModel _movieDetailViewModel;

  ReviewEditViewModel(this._createReviewUseCase, this._movieDetailViewModel,
      {required StreamController<ReviewEditUiEvent> controller,
      bool isEditMode = true})
      : uiEventController = controller {
    _state = _state.copyWith(isEditMode: isEditMode);
    _loadReview();
  }

  final StreamController<ReviewEditUiEvent> uiEventController;
  Stream<ReviewEditUiEvent> get uiEventStream => uiEventController.stream;

  ReviewEditState _state = ReviewEditState(date: DateTime.now());
  ReviewEditState get state => _state;

  void onEvent(ReviewEditEvent event) {
    event.when(
        setRating: _setRating,
        setDate: _setDate,
        changeMode: _changeMode,
        saveReview: _saveReview);
  }

  void _changeMode(bool isEditMode) {
    _state = _state.copyWith(isEditMode: isEditMode);
    notifyListeners();
  }

  void _setRating(double rating) {
    print(rating);
    _state = _state.copyWith(rating: rating);
    notifyListeners();
  }

  void _setDate(DateTime date) {
    _state = _state.copyWith(date: date);
    notifyListeners();
  }

  Future<void> _saveReview(String content, MovieDetail movieDetail) async {
    if (content.isEmpty) {
      uiEventController.add(const ReviewEditUiEvent.snackBar('감상평을 입력해주세요'));
    }
    final ReviewBuilder builder = ReviewBuilder();
    builder.movieId = movieDetail.id;
    builder.movieTitle = movieDetail.title;
    builder.posterPath = movieDetail.posterPath;
    builder.viewingDate = _state.date;
    builder.content = content;
    builder.starRating = _state.rating;

    final Review review = builder.build();

    final result = await _createReviewUseCase(review);

    result.when(success: (createResult) {
      _movieDetailViewModel.onEvent(const MovieDetailEvent.loadReview());
      _state = _state.copyWith(isEditMode: false);
      uiEventController.add(const ReviewEditUiEvent.snackBar('저장되었습니다.'));
    }, error: (message) {
      //TODO: 에러 메시지
    });

    notifyListeners();
  }

  Future<void> _loadReview() async {
    final review = _movieDetailViewModel.state.review;

    if (review != null) {
      _state = _state.copyWith(
          date: review.viewingDate,
          rating: review.starRating,
          content: review.content);
    }

    notifyListeners();
  }
}

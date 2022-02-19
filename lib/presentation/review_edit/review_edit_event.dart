import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/model/movie_detail/movie_detail.dart';

part 'review_edit_event.freezed.dart';

@freezed
class ReviewEditEvent with _$ReviewEditEvent {
  const factory ReviewEditEvent.setRating(double rating) = SetRating;
  const factory ReviewEditEvent.setDate(DateTime date) = SetDate;
  const factory ReviewEditEvent.changeMode(bool isEditMode) = ChangeMode;
  const factory ReviewEditEvent.saveReview(String content) = SaveReview;
}

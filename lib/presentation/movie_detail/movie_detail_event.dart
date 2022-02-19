import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_detail_event.freezed.dart';

@freezed
class MovieDetailEvent with _$MovieDetailEvent {
  const factory MovieDetailEvent.toggleBookmark() = ToggleBookmark;
  const factory MovieDetailEvent.loadReview() = LoadReview;
  const factory MovieDetailEvent.deleteReview() = DeleteReview;
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/model/review/review.dart';
import 'package:movie_search/domain/usecase/bookmark/util/order_type.dart';

part 'movie_bookmark_event.freezed.dart';

@freezed
class MovieBookmarkEvent with _$MovieBookmarkEvent {
  const factory MovieBookmarkEvent.load({@Default(true) bool reset}) = Load;
  const factory MovieBookmarkEvent.orderChange(OrderType orderType) =
      OrderChange;
  const factory MovieBookmarkEvent.deleteReview(Review review) = DeleteReview;
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/model/review/review.dart';
import 'package:movie_search/domain/usecase/bookmark/util/order_type.dart';

part 'movie_bookmark_state.freezed.dart';

@freezed
class MovieBookmarkState with _$MovieBookmarkState {
  const factory MovieBookmarkState({
    @Default(OrderType.date(true)) OrderType orderType,
    @Default(false) bool isLoading,
  }) = _MovieBookmarkState;
}

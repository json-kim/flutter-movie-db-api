import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/model/credit/credit.dart';
import 'package:movie_search/domain/model/movie_detail/movie_detail.dart';

part 'movie_detail_state.freezed.dart';

@freezed
class MovieDetailState with _$MovieDetailState {
  const factory MovieDetailState({
    @Default(null) MovieDetail? movieDetail,
    @Default([]) List<Credit> credits,
    @Default(false) bool isBookmarked,
    @Default(false) bool isLoading,
  }) = State;
}

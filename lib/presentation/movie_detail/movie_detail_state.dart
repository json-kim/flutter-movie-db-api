import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/model/credit/credit.dart';
import 'package:movie_search/domain/model/movie_detail/movie_detail.dart';

part 'movie_detail_state.freezed.dart';

@freezed
class MovieDetailState with _$MovieDetailState {
  const factory MovieDetailState.state(
    final MovieDetail movieDetail,
    final List<Credit> credits,
    final bool isLoading,
  ) = State;
  const factory MovieDetailState.empty() = Empty;
}

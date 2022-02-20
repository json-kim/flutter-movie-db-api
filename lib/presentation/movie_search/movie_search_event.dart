import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_search_event.freezed.dart';

@freezed
class MovieSearchEvent with _$MovieSearchEvent {
  const factory MovieSearchEvent.search({
    @Default(1) int page,
    String? query,
  }) = Search;
}

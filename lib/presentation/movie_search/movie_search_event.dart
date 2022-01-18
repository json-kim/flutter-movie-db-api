import 'package:freezed_annotation/freezed_annotation.dart';

part 'movie_search_event.freezed.dart';

@freezed
class MovieSearchEvent with _$MovieSearchEvent {
  const factory MovieSearchEvent.search(String query) = Search;
  const factory MovieSearchEvent.loadMore() = LoadMore;
  const factory MovieSearchEvent.refresh() = Refresh;
}

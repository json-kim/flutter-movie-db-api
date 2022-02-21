import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/model/search_history/search_history.dart';

part 'movie_search_event.freezed.dart';

@freezed
class MovieSearchEvent with _$MovieSearchEvent {
  const factory MovieSearchEvent.search({
    @Default(1) int page,
    String? query,
  }) = Search;

  const factory MovieSearchEvent.loadHistory() = LoadHistory;
  const factory MovieSearchEvent.saveHistory(String query) = SaveHistory;
  const factory MovieSearchEvent.deleteAllHistory() = DeleteAllHistory;
  const factory MovieSearchEvent.deleteHistory(SearchHistory history) =
      DeleteHistory;
}

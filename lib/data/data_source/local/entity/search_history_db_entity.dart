import 'package:hive/hive.dart';
import 'package:movie_search/domain/model/search_history/search_history.dart';

part 'search_history_db_entity.g.dart';

@HiveType(typeId: 1)
class SearchHistoryDbEntity {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final DateTime searchTime;

  SearchHistoryDbEntity({
    required this.id,
    required this.content,
    required this.searchTime,
  });

  SearchHistory toSearchHistory() {
    return SearchHistory(
      id: id,
      content: content,
      searchTime: searchTime,
    );
  }

  factory SearchHistoryDbEntity.fromModel(SearchHistory history) {
    return SearchHistoryDbEntity(
      id: history.id,
      content: history.content,
      searchTime: history.searchTime,
    );
  }

  @override
  String toString() {
    return 'SearchHistoryDbEntity {id: $id, content: $content, searchTime: $searchTime}';
  }
}

import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/search_history/search_history.dart';

abstract class SearchHistoryRepository {
  Future<Result<List<SearchHistory>>> getSearchHistories();

  Future<Result<int>> saveSearchHistory(SearchHistory searchHistory);

  Future<Result<int>> deleteSearchHistory(String id);

  Future<Result<int>> deleteAllHistory();
}

import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/local/entity/search_history_db_entity.dart';
import 'package:movie_search/data/data_source/local/search_history_local_data_source.dart';
import 'package:movie_search/domain/model/search_history/search_history.dart';
import 'package:movie_search/domain/repository/search_history_repository.dart';

class SearchHistoryRepositoryImpl implements SearchHistoryRepository {
  final SearchHistoryLocalDataSource _localDataSource;

  SearchHistoryRepositoryImpl(this._localDataSource);

  @override
  Future<Result<int>> deleteAllHistory() async {
    final result = await _localDataSource.deleteAll();

    return result.when(success: (deleteResult) {
      return Result.success(deleteResult);
    }, error: (message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<int>> deleteSearchHistory(String id) async {
    final result = await _localDataSource.deleteSearchHistory(id);

    return result.when(success: (deleteResult) {
      return Result.success(deleteResult);
    }, error: (message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<List<SearchHistory>>> getSearchHistories() async {
    final result = await _localDataSource.getSearchHistories();

    return result.when(success: (entityList) {
      try {
        final historyList = entityList.map((e) => e.toSearchHistory()).toList();

        return Result.success(historyList);
      } catch (e) {
        return Result.error(
            '$runtimeType.getSearchHistories : 에러 발생 entity -> model \n$e');
      }
    }, error: (message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<int>> saveSearchHistory(SearchHistory searchHistory) async {
    try {
      final entity = SearchHistoryDbEntity.fromModel(searchHistory);

      final result = await _localDataSource.saveSearchHistory(entity);

      return result.when(success: (saveResult) {
        return Result.success(saveResult);
      }, error: (message) {
        return Result.error(message);
      });
    } catch (e) {
      return Result.error(
          '$runtimeType.saveSearchHistory : 에러 발생 Model -> entity \n$e');
    }
  }
}

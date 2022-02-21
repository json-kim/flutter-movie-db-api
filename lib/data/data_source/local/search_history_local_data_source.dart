import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/local/entity/search_history_db_entity.dart';

class SearchHistoryLocalDataSource {
  final Box<SearchHistoryDbEntity> _box;

  SearchHistoryLocalDataSource(this._box);

  Future<Result<List<SearchHistoryDbEntity>>> getSearchHistories() async {
    final entityList = _box.values.toList();

    return Result.success(entityList);
  }

  /// 성공시 1, 실패시 -1
  Future<Result<int>> deleteAll() async {
    await _box.deleteAll(_box.keys);

    return const Result.success(1);
  }

  /// 성공시 1, 실패시 -1
  Future<Result<int>> deleteSearchHistory(String historyId) async {
    await _box.delete(historyId);

    return const Result.success(1);
  }

  /// 성공시 1, 실패시 -1
  Future<Result<int>> saveSearchHistory(SearchHistoryDbEntity entity) async {
    await _box.put(entity.id, entity);

    return const Result.success(1);
  }
}

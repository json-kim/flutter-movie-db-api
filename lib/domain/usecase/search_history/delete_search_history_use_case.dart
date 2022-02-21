import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/repository/search_history_repository.dart';

import '../use_case.dart';

class DeleteSearchHistoryUseCase implements UseCase<int, String> {
  final SearchHistoryRepository _searchHistoryRepository;

  DeleteSearchHistoryUseCase(this._searchHistoryRepository);

  @override
  Future<Result<int>> call(String historyId) async {
    final result =
        await _searchHistoryRepository.deleteSearchHistory(historyId);

    return result.when(
      success: (deleteResult) {
        return Result.success(deleteResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}

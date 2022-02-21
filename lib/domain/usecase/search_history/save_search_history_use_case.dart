import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/search_history/search_history.dart';
import 'package:movie_search/domain/repository/search_history_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class SaveSearchHistoryUseCase implements UseCase<int, SearchHistory> {
  final SearchHistoryRepository _searchHistoryRepository;

  SaveSearchHistoryUseCase(this._searchHistoryRepository);

  @override
  Future<Result<int>> call(SearchHistory searchHistory) async {
    final result =
        await _searchHistoryRepository.saveSearchHistory(searchHistory);

    return result.when(
      success: (saveResult) {
        return Result.success(saveResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}

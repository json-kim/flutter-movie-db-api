import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/search_history/search_history.dart';
import 'package:movie_search/domain/repository/search_history_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetSearchHistoriesUseCase implements UseCase<List<SearchHistory>, void> {
  final SearchHistoryRepository _searchHistoryRepository;

  GetSearchHistoriesUseCase(this._searchHistoryRepository);

  @override
  Future<Result<List<SearchHistory>>> call(void params) async {
    final result = await _searchHistoryRepository.getSearchHistories();

    return result.when(
      success: (historyList) {
        historyList.sort((a, b) => -a.searchTime.millisecondsSinceEpoch
            .compareTo(b.searchTime.millisecondsSinceEpoch));
        return Result.success(historyList);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}

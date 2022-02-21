import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/repository/search_history_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class DeleteAllHistoryUseCase implements UseCase<int, void> {
  final SearchHistoryRepository _searchHistoryRepository;

  DeleteAllHistoryUseCase(this._searchHistoryRepository);

  @override
  Future<Result<int>> call(void params) async {
    final result = await _searchHistoryRepository.deleteAllHistory();

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

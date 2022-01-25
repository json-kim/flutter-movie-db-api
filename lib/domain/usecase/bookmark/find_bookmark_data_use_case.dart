import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/repository/bookmark_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class FindBookmarkDataUseCase<DataType> implements UseCase<DataType, int> {
  final BookmarkDataRepository<DataType, int> _repository;

  FindBookmarkDataUseCase(this._repository);

  @override
  Future<Result<DataType>> call(int id) async {
    final result = await _repository.loadData(id);

    return result.when(
      success: (data) {
        return Result.success(data);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}

import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/repository/bookmark_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class DeleteBookmarkDataUseCase<DataType> implements UseCase<int, int> {
  final BookmarkDataRepository<DataType, int> _repository;

  DeleteBookmarkDataUseCase(this._repository);

  @override
  Future<Result<int>> call(int id) async {
    final result = await _repository.deleteData(id);

    return result.when(
      success: (movieId) {
        return Result.success(movieId);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}

import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/repository/bookmark_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class SaveBookmarkDataUseCase<DataType> implements UseCase<int, DataType> {
  final BookmarkDataRepository<DataType, int> _repository;

  SaveBookmarkDataUseCase(this._repository);

  @override
  Future<Result<int>> call(DataType movie) async {
    final result = await _repository.saveData(movie);

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

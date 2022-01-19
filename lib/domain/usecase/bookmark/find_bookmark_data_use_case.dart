import 'package:movie_search/core/resources/resultrk_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class FindBookmarkDataUseCase<DataType> implements UseCase<DataType, int> {
  final BookmarkDataRepository<DataType, int> _repository;

  FindBookmarkDataUseCase(this._repository);

  @override
  Future<Result<DataType>> call(int movieId) async {
    final result = await _repository.loadData(movieId);

    return result.when(
      success: (movie) {
        return Result.success(movie);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}

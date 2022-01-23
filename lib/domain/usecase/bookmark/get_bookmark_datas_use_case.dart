import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/repository/bookmark_data_repository.dart';

import '../use_case.dart';

class GetBookmarkDatasUseCase<DataType>
    implements UseCase<List<DataType>, int> {
  final BookmarkDataRepository<DataType, int> _repository;

  GetBookmarkDatasUseCase(this._repository);

  @override
  Future<Result<List<DataType>>> call(int page) async {
    final result = await _repository.loadDataList(page);

    return result.when(success: (movies) {
      return Result.success(movies);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

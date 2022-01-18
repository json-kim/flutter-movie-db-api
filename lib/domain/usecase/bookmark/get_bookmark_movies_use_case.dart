import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/repository/bookmark_data_repository.dart';

import '../use_case.dart';

class GetBookmarkMoviesUseCase implements UseCase<List<Movie>, int> {
  final BookmarkDataRepository<Movie, int> _repository;

  GetBookmarkMoviesUseCase(this._repository);

  @override
  Future<Result<List<Movie>>> call(int page) async {
    final result = await _repository.loadDatas(page);

    return result.when(success: (movies) {
      return Result.success(movies);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

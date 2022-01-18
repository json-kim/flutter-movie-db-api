import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/repository/bookmark_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class DeleteBookmarkMovieUseCase implements UseCase<int, int> {
  final BookmarkDataRepository<Movie, int> _repository;

  DeleteBookmarkMovieUseCase(this._repository);

  @override
  Future<Result<int>> call(int movieId) async {
    final result = await _repository.deleteData(movieId);

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

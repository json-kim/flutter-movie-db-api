import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/repository/bookmark_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class FindBookmarkMovieUseCase implements UseCase<Movie, int> {
  final BookmarkDataRepository<Movie, int> _repository;

  FindBookmarkMovieUseCase(this._repository);

  @override
  Future<Result<Movie>> call(int movieId) async {
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

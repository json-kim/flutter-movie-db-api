import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/repository/bookmark_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class SaveBookmarkMovieUseCase implements UseCase<int, Movie> {
  final BookmarkDataRepository<Movie, int> _repository;

  SaveBookmarkMovieUseCase(this._repository);

  @override
  Future<Result<int>> call(Movie movie) async {
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

import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetMoviePopularUseCase implements UseCase<List<Movie>, Param> {
  final MovieDataRepository<List<Movie>, Param> _repository;

  GetMoviePopularUseCase(this._repository);

  @override
  Future<Result<List<Movie>>> call(Param param) async {
    final result = await _repository.fetch(param);

    return result.when(success: (movies) {
      return Result.success(movies);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

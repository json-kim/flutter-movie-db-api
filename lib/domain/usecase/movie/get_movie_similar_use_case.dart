import 'package:movie_search/core/page/page.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetMovieSimilarUseCase implements UseCase<Page<Movie>, Param> {
  final MovieDataRepository<Page<Movie>, Param> _repository;

  GetMovieSimilarUseCase(this._repository);

  @override
  Future<Result<Page<Movie>>> call(Param param) async {
    final result = await _repository.fetch(param);

    return result.when(success: (page) {
      return Result.success(page);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

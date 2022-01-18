import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetMoviePopularUseCase implements UseCase<List<Movie>, int> {
  final MovieDataRepository<Movie, RequestParams> _repository;

  GetMoviePopularUseCase(this._repository);

  @override
  Future<Result<List<Movie>>> call(int page) async {
    final params =
        RequestParamsWithPage(pathParams: 'movie/popular', page: page);

    final result = await _repository.fetch(params);

    return result.when(success: (movies) {
      return Result.success(movies);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

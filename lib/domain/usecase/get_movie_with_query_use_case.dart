import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/entity/movie/movie.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetMovieWithQueryUseCase
    implements UseCase<Result<List<Movie>>, RequestParamsWithQuery> {
  @override
  final MovieDataRepository<Movie, RequestParams> repository;

  GetMovieWithQueryUseCase(this.repository);

  @override
  Future<Result<List<Movie>>> call(RequestParamsWithQuery param) async {
    final params = RequestParamsWithQuery(query: '스파이더맨');

    final result = await repository.fetch(params);

    return result.when(success: (movies) {
      return Result.success(movies);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

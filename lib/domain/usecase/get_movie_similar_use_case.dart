import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetMovieSimilarUseCase implements UseCase<Result<List<Movie>>, Movie> {
  @override
  final MovieDataRepository<Movie, RequestParams> repository;

  GetMovieSimilarUseCase(this.repository);

  @override
  Future<Result<List<Movie>>> call(Movie movie) async {
    final params =
        RequestParamsWithPage(pathParams: 'movie/${movie.id}/similar');

    final result = await repository.fetch(params);

    return result.when(success: (movies) {
      return Result.success(movies);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

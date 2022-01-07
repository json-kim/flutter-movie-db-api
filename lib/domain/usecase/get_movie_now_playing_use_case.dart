import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/entity/movie/movie.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetMovieNowPlayingUseCase implements UseCase<Result<List<Movie>>, int> {
  @override
  final MovieDataRepository<Movie, RequestParams> repository;

  GetMovieNowPlayingUseCase(this.repository);

  @override
  Future<Result<List<Movie>>> call(int page) async {
    final params =
        RequestParamsWithPage(pathParams: 'movie/now_playing', page: page);

    final result = await repository.fetch(params);

    return result.when(success: (movies) {
      return Result.success(movies.take(10).toList());
    }, error: (message) {
      return Result.error(message);
    });
  }
}

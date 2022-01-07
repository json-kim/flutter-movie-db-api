import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/entity/movie_detail/movie_detail.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetMovieDetailUseCase implements UseCase<Result<MovieDetail>, int> {
  @override
  final MovieDataRepository<MovieDetail, RequestParams> repository;

  GetMovieDetailUseCase(this.repository);

  @override
  Future<Result<MovieDetail>> call(int movieId) async {
    final params = RequestParams(pathParams: 'movie/$movieId');
    final result = await repository.fetch(params);

    return result.when(success: (movieDetails) {
      return Result.success(movieDetails.first);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

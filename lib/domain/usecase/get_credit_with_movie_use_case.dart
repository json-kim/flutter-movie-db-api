import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/entity/credit/credit.dart';
import 'package:movie_search/domain/entity/movie/movie.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetCreditWithMovieUseCase
    implements UseCase<Result<List<Credit>>, Movie> {
  @override
  final MovieDataRepository<Credit, RequestParams> repository;

  GetCreditWithMovieUseCase(this.repository);

  @override
  Future<Result<List<Credit>>> call(Movie movie) async {
    final params = RequestParams(pathParams: 'movie/${movie.id}/credits');

    final result = await repository.fetch(params);

    return result.when(success: (credits) {
      return Result.success(credits);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

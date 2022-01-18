import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetMovieWithKeywordUseCase
    implements UseCase<List<Movie>, RequestParams> {
  final MovieDataRepository<Movie, RequestParams> _repository;

  GetMovieWithKeywordUseCase(this._repository);

  @override
  Future<Result<List<Movie>>> call(RequestParams param) async {
    final keywordId = 9715;
    final params =
        RequestParamsWithPage(pathParams: 'keyword/$keywordId/movies');

    final result = await _repository.fetch(params);

    return result.when(success: (movies) {
      return Result.success(movies);
    }, error: (message) {
      return Result.error(message);
    });
  }
}
import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/model/keyword/keyword.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetKeywordWithMovieUseCase
    implements UseCase<List<Keyword>, RequestParams> {
  final MovieDataRepository<Keyword, RequestParams> _repository;

  GetKeywordWithMovieUseCase(this._repository);

  @override
  Future<Result<List<Keyword>>> call(RequestParams param) async {
    final movieId = 634649;
    final params = RequestParams(pathParams: 'movie/$movieId/keywords');

    final result = await _repository.fetch(params);

    return result.when(success: (keywords) {
      return Result.success(keywords);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

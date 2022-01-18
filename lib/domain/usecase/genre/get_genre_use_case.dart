import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/model/genre/genre.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetGenreUseCase implements UseCase<List<Genre>, void> {
  final MovieDataRepository<Genre, RequestParams> _repository;

  GetGenreUseCase(this._repository);

  @override
  Future<Result<List<Genre>>> call(void params) async {
    final params = RequestParams(pathParams: 'genre/movie/list');

    final result = await _repository.fetch(params);

    return result.when(success: (genres) {
      return Result.success(genres);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

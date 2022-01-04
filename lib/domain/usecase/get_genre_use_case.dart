import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/entity/genre/genre.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetGenreUseCase implements UseCase<Result<List<Genre>>, void> {
  @override
  final MovieDataRepository<Genre, RequestParams> repository;

  GetGenreUseCase(this.repository);

  @override
  Future<Result<List<Genre>>> call(params) async {
    final params = RequestParams(pathParams: 'genre/movie/list');

    final result = await repository.fetch(params);

    return result.when(success: (genres) {
      return Result.success(genres);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

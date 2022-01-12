import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetMovieWithQueryUseCase implements UseCase<List<Movie>, String> {
  final MovieDataRepository<Movie, RequestParams> _repository;

  GetMovieWithQueryUseCase(this._repository);

  @override
  Future<Result<List<Movie>>> call(String query) async {
    final params = RequestParamsWithQuery(query: queryChange(query));

    final result = await _repository.fetch(params);

    return result.when(success: (movies) {
      return Result.success(movies);
    }, error: (message) {
      return Result.error(message);
    });
  }

  String queryChange(String query) {
    return (query.split(' ')..removeWhere((e) => e.trim().isEmpty)).join('+');
  }
}

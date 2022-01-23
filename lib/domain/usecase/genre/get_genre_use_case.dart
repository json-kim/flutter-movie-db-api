import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/genre/genre.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetGenreUseCase implements UseCase<List<Genre>, Param> {
  final MovieDataRepository<List<Genre>, Param> _repository;

  GetGenreUseCase(this._repository);

  @override
  Future<Result<List<Genre>>> call(Param param) async {
    final result = await _repository.fetch(param);

    return result.when(success: (genres) {
      return Result.success(genres);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

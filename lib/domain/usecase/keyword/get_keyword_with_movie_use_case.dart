import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/keyword/keyword.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetKeywordWithMovieUseCase implements UseCase<List<Keyword>, Param> {
  final MovieDataRepository<List<Keyword>, Param> _repository;

  GetKeywordWithMovieUseCase(this._repository);

  @override
  Future<Result<List<Keyword>>> call(Param param) async {
    final result = await _repository.fetch(param);

    return result.when(success: (keywords) {
      return Result.success(keywords);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

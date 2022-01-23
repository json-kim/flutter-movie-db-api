import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/credit/credit.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetCreditWithMovieUseCase implements UseCase<List<Credit>, Param> {
  final MovieDataRepository<List<Credit>, Param> _repository;

  GetCreditWithMovieUseCase(this._repository);

  @override
  Future<Result<List<Credit>>> call(Param param) async {
    final result = await _repository.fetch(param);

    return result.when(success: (credits) {
      return Result.success(credits);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/cast/cast.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetCastWithPersonUseCase implements UseCase<List<Cast>, Param> {
  final MovieDataRepository<List<Cast>, Param> _repository;

  GetCastWithPersonUseCase(this._repository);

  @override
  Future<Result<List<Cast>>> call(Param param) async {
    final result = await _repository.fetch(param);

    return result.when(success: (credits) {
      return Result.success(credits);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

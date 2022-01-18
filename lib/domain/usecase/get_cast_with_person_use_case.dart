import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/model/cast/cast.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetCastWithPersonUseCase implements UseCase<List<Cast>, int> {
  final MovieDataRepository<Cast, RequestParams> _repository;

  GetCastWithPersonUseCase(this._repository);

  @override
  Future<Result<List<Cast>>> call(int personId) async {
    final params = RequestParams(pathParams: 'person/$personId/movie_credits');

    final result = await _repository.fetch(params);

    return result.when(success: (credits) {
      return Result.success(credits);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

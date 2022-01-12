import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetPersonDetailUseCase implements UseCase<List<Person>, RequestParams> {
  final MovieDataRepository<Person, RequestParams> _repository;

  GetPersonDetailUseCase(this._repository);

  @override
  Future<Result<List<Person>>> call(RequestParams param) async {
    final personId = 287;
    final params = RequestParams(pathParams: 'person/$personId');

    final result = await _repository.fetch(params);

    return result.when(success: (person) {
      return Result.success(person);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

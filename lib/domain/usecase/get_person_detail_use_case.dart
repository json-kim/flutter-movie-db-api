import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/entity/person/person.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetPersonDetailUseCase
    implements UseCase<Result<List<Person>>, RequestParams> {
  @override
  final MovieDataRepository<Person, RequestParams> repository;

  GetPersonDetailUseCase(this.repository);

  @override
  Future<Result<List<Person>>> call(RequestParams param) async {
    final personId = 287;
    final params = RequestParams(pathParams: 'person/$personId');

    final result = await repository.fetch(params);

    return result.when(success: (person) {
      return Result.success(person);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

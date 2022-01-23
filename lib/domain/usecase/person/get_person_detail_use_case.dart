import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetPersonDetailUseCase implements UseCase<Person, Param> {
  final MovieDataRepository<Person, Param> _repository;

  GetPersonDetailUseCase(this._repository);

  @override
  Future<Result<Person>> call(Param param) async {
    final result = await _repository.fetch(param);

    return result.when(success: (person) {
      return Result.success(person);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

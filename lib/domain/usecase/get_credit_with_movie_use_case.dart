import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/entity/credit/credit.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetCreditWithMovieUseCase
    implements UseCase<Result<List<Credit>>, RequestParams> {
  final MovieDataRepository repository;

  GetCreditWithMovieUseCase(this.repository);

  @override
  Future<Result<List<Credit>>> call(RequestParams param) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

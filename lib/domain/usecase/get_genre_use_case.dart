import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/entity/genre/genre.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetGenreUseCase implements UseCase<Result<List<Genre>>, RequestParams> {
  final MovieDataRepository repository;

  GetGenreUseCase(this.repository);

  @override
  Future<Result<List<Genre>>> call(RequestParams param) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

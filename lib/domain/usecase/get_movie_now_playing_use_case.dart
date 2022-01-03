import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/entity/movie/movie.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetMovieNowPlayingUseCase
    implements UseCase<Result<List<Movie>>, RequestParams> {
  final MovieDataRepository repository;

  GetMovieNowPlayingUseCase(this.repository);

  @override
  Future<Result<List<Movie>>> call(RequestParams param) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

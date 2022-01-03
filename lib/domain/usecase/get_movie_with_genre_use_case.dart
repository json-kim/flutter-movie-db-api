import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/entity/movie/movie.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

import 'use_case.dart';

class GetMovieWithGenreUseCase
    implements UseCase<Result<List<Movie>>, RequestParamsWithGenre> {
  final MovieDataRepository repository;

  GetMovieWithGenreUseCase(this.repository);

  @override
  Future<Result<List<Movie>>> call(RequestParamsWithGenre param) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

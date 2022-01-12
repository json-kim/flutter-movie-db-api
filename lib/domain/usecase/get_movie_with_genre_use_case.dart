import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/model/genre/genre.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

import 'use_case.dart';

class GetMovieWithGenreUseCase implements UseCase<Result<List<Movie>>, Genre> {
  @override
  final MovieDataRepository<Movie, RequestParams> repository;

  GetMovieWithGenreUseCase(this.repository);

  @override
  Future<Result<List<Movie>>> call(Genre genre) async {
    final params = RequestParamsWithGenre(genreId: genre.id);

    final result = await repository.fetch(params);

    return result.when(success: (movies) {
      return Result.success(movies);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

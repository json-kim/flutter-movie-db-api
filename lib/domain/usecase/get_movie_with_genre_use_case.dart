import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/model/genre/genre.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

import 'use_case.dart';

class GetMovieWithGenreUseCase implements UseCase<List<Movie>, Genre> {
  final MovieDataRepository<Movie, RequestParams> _repository;

  GetMovieWithGenreUseCase(this._repository);

  @override
  Future<Result<List<Movie>>> call(Genre genre) async {
    final params = RequestParamsWithGenre(genreId: genre.id);

    final result = await _repository.fetch(params);

    return result.when(success: (movies) {
      return Result.success(movies);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

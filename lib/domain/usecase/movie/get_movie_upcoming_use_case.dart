import 'package:movie_search/core/page/page.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

import '../use_case.dart';

class GetMovieUpcomingUseCase implements UseCase<Page<Movie>, Param> {
  final MovieDataRepository<Page<Movie>, Param> _repository;

  GetMovieUpcomingUseCase(this._repository);

  @override
  Future<Result<Page<Movie>>> call(Param param) async {
    final result = await _repository.fetch(param);
    // final box = Hive.box('alarm');

    return result.when(success: (page) {
      page.items.sort((movieA, movieB) => (movieA.releaseDate ?? '2099-01-01')
          .compareTo((movieB.releaseDate ?? '2099-01-01')));

      return Result.success(page);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

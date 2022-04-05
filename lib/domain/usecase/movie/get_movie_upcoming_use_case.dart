import 'package:hive/hive.dart';
import 'package:movie_search/core/page/page.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/movie/data/movie_upcoming.dart';

import '../use_case.dart';

class GetMovieUpcomingUseCase implements UseCase<Page<Movie>, Param> {
  final MovieDataRepository<Page<Movie>, Param> _repository;

  GetMovieUpcomingUseCase(this._repository);

  @override
  Future<Result<Page<Movie>>> call(Param param) async {
    final result = await _repository.fetch(param);
    // final box = Hive.box('alarm');

    return result.when(success: (page) {
      // final alarmMoviePage = Page(
      //     currentPage: page.currentPage,
      //     lastPage: page.lastPage,
      //     items: page.items.map((movie) {
      //       final isAlarmed = box.containsKey(movie.id);

      //       return MovieUpcomingData.fromMovie(movie, isAlarmed);
      //     }).toList());

      return Result.success(page);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

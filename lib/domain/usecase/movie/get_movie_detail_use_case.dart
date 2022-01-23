import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/movie_detail/movie_detail.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetMovieDetailUseCase implements UseCase<MovieDetail, Param> {
  final MovieDataRepository<MovieDetail, Param> _repository;

  GetMovieDetailUseCase(this._repository);

  @override
  Future<Result<MovieDetail>> call(Param param) async {
    final result = await _repository.fetch(param);

    return result.when(success: (movieDetails) {
      return Result.success(movieDetails);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

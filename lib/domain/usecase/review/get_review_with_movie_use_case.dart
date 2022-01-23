import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/review/review.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetReviewWithMovieUseCase implements UseCase<List<Review>, Param> {
  final MovieDataRepository<List<Review>, Param> _repository;

  GetReviewWithMovieUseCase(this._repository);

  @override
  Future<Result<List<Review>>> call(Param param) async {
    final result = await _repository.fetch(param);

    return result.when(success: (reviews) {
      return Result.success(reviews);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

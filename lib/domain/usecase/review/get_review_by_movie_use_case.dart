import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/repository/review_data_repository.dart';

import '../../model/review/review.dart';
import '../use_case.dart';

class GetReviewByMovieUseCase implements UseCase<Review, int> {
  final ReviewDataRepository _reviewDataRepository;

  GetReviewByMovieUseCase(this._reviewDataRepository);

  @override
  Future<Result<Review>> call(int movieId) async {
    final result = await _reviewDataRepository.loadReviewByMovie(movieId);

    return result.when(success: (review) {
      return Result.success(review);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

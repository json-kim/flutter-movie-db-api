import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/repository/review_data_repository.dart';

import '../../model/review/review.dart';
import '../use_case.dart';

class UpdateReviewUseCase implements UseCase<String, Review> {
  final ReviewDataRepository _reviewDataRepository;

  UpdateReviewUseCase(this._reviewDataRepository);

  @override
  Future<Result<String>> call(Review review) async {
    final result = await _reviewDataRepository.updateReview(review);

    return result.when(success: (reviewId) {
      return Result.success(reviewId);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

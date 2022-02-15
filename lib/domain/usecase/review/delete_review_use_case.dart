import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/repository/review_data_repository.dart';

import '../use_case.dart';

class DeleteReviewUseCase implements UseCase<bool, String> {
  final ReviewDataRepository _reviewDataRepository;

  DeleteReviewUseCase(this._reviewDataRepository);

  @override
  Future<Result<bool>> call(String reviewId) async {
    final result = await _reviewDataRepository.deleteReview(reviewId);

    return result.when(success: (deleteResult) {
      return Result.success(deleteResult);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

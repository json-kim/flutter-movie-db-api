import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/repository/review_data_repository.dart';

import '../../model/review/review.dart';
import '../use_case.dart';

class GetReviewUseCase implements UseCase<List<Review>, int> {
  final ReviewDataRepository _reviewDataRepository;

  GetReviewUseCase(this._reviewDataRepository);

  @override
  Future<Result<List<Review>>> call(int page) async {
    final result = await _reviewDataRepository.loadReview(page);

    return result.when(success: (reviews) {
      return Result.success(reviews);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

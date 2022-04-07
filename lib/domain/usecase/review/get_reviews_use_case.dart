import 'package:movie_search/core/page/page.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/repository/review_data_repository.dart';

import '../../model/review/review.dart';
import '../use_case.dart';

class GetReviewsUseCase implements UseCase<Page<Review>, int> {
  final ReviewDataRepository _reviewDataRepository;

  GetReviewsUseCase(this._reviewDataRepository);

  @override
  Future<Result<Page<Review>>> call(int page) async {
    final result = await _reviewDataRepository.loadReviews(page);

    return result.when(success: (reviews) {
      return Result.success(reviews);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

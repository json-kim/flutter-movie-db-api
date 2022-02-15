import 'package:movie_search/core/result/result.dart';

import '../model/review/review.dart';

abstract class ReviewDataRepository {
  Future<Result<List<Review>>> loadReview(int page);

  Future<Result<String>> createReview(Review review);

  Future<Result<String>> updateReview(Review review);

  Future<Result<bool>> deleteReview(String reviewId);
}

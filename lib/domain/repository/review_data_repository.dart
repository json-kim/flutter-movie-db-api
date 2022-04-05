import 'package:movie_search/core/result/result.dart';

import '../model/review/review.dart';

abstract class ReviewDataRepository {
  Future<Result<List<Review>>> loadAllReviews();

  Future<Result<List<Review>>> loadReviews(int page);

  Future<Result<Review>> loadReviewByMovie(int movieId);

  Future<Result<int>> createReview(Review review);

  Future<Result<int>> updateReview(Review review);

  Future<Result<bool>> deleteReview(String reviewId);

  Future<Result<void>> deleteAll();

  Future<Result<void>> restoreReviews(List<Review> reviews);
}

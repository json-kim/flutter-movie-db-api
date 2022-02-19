import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/local/entity/review_db_entity.dart';
import 'package:movie_search/data/data_source/local/review_local_data_source.dart';
import 'package:movie_search/domain/model/review/review.dart';
import 'package:movie_search/domain/repository/review_data_repository.dart';

class ReviewDataRepositoryImple implements ReviewDataRepository {
  final ReviewLocalDataSource _dataSource;

  ReviewDataRepositoryImple(this._dataSource);

  @override
  Future<Result<int>> createReview(Review review) async {
    final ReviewDbEntity entity = ReviewDbEntity.fromReview(review);

    final result = await _dataSource.insertReview(entity);

    return result.when(success: (insertResult) {
      return Result.success(insertResult);
    }, error: (message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<bool>> deleteReview(String reviewId) async {
    final result = await _dataSource.deleteReview(reviewId);

    return result.when(success: (isDelete) {
      return Result.success(isDelete);
    }, error: (message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<Review>> loadReviewByMovie(int movieId) async {
    final result = await _dataSource.getReviewByMovie(movieId);

    return result.when(success: (entity) {
      final review = entity.toReview();

      return Result.success(review);
    }, error: (message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<List<Review>>> loadReviews(int page) async {
    final result = await _dataSource.getReviews(page);

    return result.when(success: (entities) {
      final List<Review> reviews = entities.map((e) => e.toReview()).toList();

      return Result.success(reviews);
    }, error: (message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<int>> updateReview(Review review) async {
    final entity = ReviewDbEntity.fromReview(review);

    final result = await _dataSource.updateReview(entity);

    return result.when(success: (updateResult) {
      return Result.success(updateResult);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

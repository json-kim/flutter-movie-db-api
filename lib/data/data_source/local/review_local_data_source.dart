import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/local/entity/review_db_entity.dart';
import 'package:sqflite/sqflite.dart';

class ReviewLocalDataSource {
  Database _db;

  ReviewLocalDataSource(this._db);

  /// db에서 영화 id로 리뷰 가져오기
  Future<Result<ReviewDbEntity>> getReviewByMovie(int movieId) async {
    final List<Map<String, dynamic>> maps =
        await _db.query('review', where: 'movieId = ?', whereArgs: [movieId]);

    if (maps.isNotEmpty) {
      return Result.success(ReviewDbEntity.fromJson(maps.first));
    } else {
      return Result.error(
          '$runtimeType.getReviewByMovie : 에러 발생 - 리뷰를 찾을 수 없습니다.');
    }
  }

  /// db에서 리뷰 리스트 가져오기
  Future<Result<List<ReviewDbEntity>>> getReviews(int page) async {
    final List<Map<String, dynamic>> maps =
        await _db.query('review', offset: (page - 1) * 20, limit: 20);

    if (maps.isNotEmpty) {
      final List<ReviewDbEntity> entities =
          maps.map((e) => ReviewDbEntity.fromJson(e)).toList();
      return Result.success(entities);
    } else {
      return Result.error('$runtimeType.getReviews : 에러 발생 - 저장된 리뷰가 없습니다.');
    }
  }

  /// db에 리뷰 삽입하기
  /// 이미 존재할 시 업데이트
  Future<Result<int>> insertReview(ReviewDbEntity reviewDbEntity) async {
    final searchResult = await _db.query('review',
        where: 'movieId = ?', whereArgs: [reviewDbEntity.movieId]);

    final result;
    if (searchResult.isNotEmpty) {
      result = await _db.update('review', reviewDbEntity.toJson(),
          where: 'movieId = ?', whereArgs: [reviewDbEntity.movieId]);
    } else {
      result = await _db.insert('review', reviewDbEntity.toJson());
    }

    if (result == 0) {
      return Result.error(
          '$runtimeType.insertReview : 에러 발생 - 데이터 삽입에 실패했습니다.');
    }

    return Result.success(result);
  }

  /// db에 리뷰 수정하기
  Future<Result<int>> updateReview(ReviewDbEntity reviewDbEntity) async {
    final result = await _db.update('review', reviewDbEntity.toJson(),
        where: 'id = ?', whereArgs: [reviewDbEntity.id]);

    if (result < 1) {
      return Result.error('$runtimeType.updateReview : 에러 발생 - 리뷰 수정 실패');
    } else {
      return Result.success(result);
    }
  }

  /// db에 리뷰 삭제하기
  Future<Result<bool>> deleteReview(String reviewId) async {
    final result =
        await _db.delete('review', where: 'id = ?', whereArgs: [reviewId]);

    if (result < 1) {
      return Result.error('$runtimeType.deleteReview : 에러 발생 - 리뷰 삭제 실패했습니다.');
    } else {
      return const Result.success(true);
    }
  }
}

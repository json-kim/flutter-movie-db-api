import 'package:movie_search/domain/model/review/review.dart';

class ReviewDbEntity {
  final String uid;
  final String id;
  final int movieId;
  final String movieTitle;
  final String? posterPath;
  final double starRating;
  final String content;
  final String createdAt;
  final String viewingDate;

  ReviewDbEntity({
    required this.uid,
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.posterPath,
    required this.starRating,
    required this.content,
    required this.createdAt,
    required this.viewingDate,
  });

  factory ReviewDbEntity.fromJson(Map<String, dynamic> json) {
    return ReviewDbEntity(
      uid: json['uid'] as String,
      id: json['id'] as String,
      movieId: json['movieId'] as int,
      movieTitle: json['movieTitle'] as String,
      posterPath: json['posterPath'] as String?,
      starRating: json['starRating'] / 1,
      content: json['content'] as String,
      createdAt: json['createdAt'] as String,
      viewingDate: json['viewingDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'id': id,
      'movieId': movieId,
      'movieTitle': movieTitle,
      'posterPath': posterPath,
      'starRating': starRating,
      'content': content,
      'createdAt': createdAt,
      'viewingDate': viewingDate,
    };
  }

  factory ReviewDbEntity.fromReview(Review review, String uid) {
    return ReviewDbEntity(
      uid: uid,
      id: review.id,
      movieId: review.movieId,
      movieTitle: review.movieTitle,
      posterPath: review.posterPath,
      starRating: review.starRating,
      content: review.content,
      createdAt: review.createdAt.toIso8601String(),
      viewingDate: review.viewingDate.toIso8601String(),
    );
  }

  Review toReview() {
    return Review(
      id: id,
      movieId: movieId,
      movieTitle: movieTitle,
      posterPath: posterPath,
      starRating: starRating,
      content: content,
      createdAt: DateTime.parse(createdAt),
      viewingDate: DateTime.parse(viewingDate),
    );
  }

  String toRawValues() {
    return '("$uid", "$id", $movieId, "$movieTitle", "$posterPath", $starRating, "$content", "$createdAt", "$viewingDate")';
  }
}

import 'package:movie_search/domain/model/review/review.dart';

class ReviewBuilder {
  int? movieId;
  double? starRating;
  String? content;
  DateTime? viewingDate;

  Review build() {
    if (movieId == null ||
        starRating == null ||
        content == null ||
        viewingDate == null) {
      throw Exception('값 미 입력');
    }

    final DateTime createdAt = DateTime.now();
    final String id = '$movieId${createdAt.millisecondsSinceEpoch}';

    return Review(
        id: id,
        movieId: movieId!,
        starRating: starRating!,
        content: content!,
        viewingDate: viewingDate!,
        createdAt: createdAt);
  }
}

import 'package:movie_search/domain/model/movie_detail/movie_detail.dart';
import 'package:movie_search/domain/model/review/review.dart';

class ReviewBuilder {
  int? movieId;
  String? movieTitle;
  String? posterPath;
  double? starRating;
  String? content;
  DateTime? viewingDate;

  void setFromReview(Review review) {
    movieId = review.movieId;
    movieTitle = review.movieTitle;
    posterPath = review.posterPath;
  }

  void setFromMovieDetail(MovieDetail movieDetail) {
    movieId = movieDetail.id;
    movieTitle = movieDetail.title;
    posterPath = movieDetail.posterPath;
  }

  Review build() {
    if (movieId == null ||
        movieTitle == null ||
        posterPath == null ||
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
        movieTitle: movieTitle!,
        posterPath: posterPath,
        starRating: starRating!,
        content: content!,
        viewingDate: viewingDate!,
        createdAt: createdAt);
  }
}

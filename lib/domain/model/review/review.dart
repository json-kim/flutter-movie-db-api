class Review {
  final String id;
  final int movieId;
  final double starRating;
  final String content;
  final String createdAt;
  final String updatedAt;

  Review({
    required this.id,
    required this.movieId,
    required this.starRating,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
}

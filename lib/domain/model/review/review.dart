class Review {
  final String id;
  final int movieId;
  final String movieTitle;
  final String? posterPath;
  final double starRating;
  final String content;
  final DateTime createdAt;
  final DateTime viewingDate;

  Review({
    required this.id,
    required this.movieId,
    required this.movieTitle,
    required this.posterPath,
    required this.starRating,
    required this.content,
    required this.createdAt,
    required this.viewingDate,
  });

  @override
  String toString() {
    return 'Review {id: $id, content: $content}';
  }
}

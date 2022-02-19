class Review {
  final String id;
  final int movieId;
  final double starRating;
  final String content;
  final DateTime createdAt;
  final DateTime viewingDate;

  Review({
    required this.id,
    required this.movieId,
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

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

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      movieId: json['movieId'],
      movieTitle: json['movieTitle'],
      posterPath: json['posterPath'],
      starRating: json['starRating'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      viewingDate: DateTime.parse(json['viewingDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'movieId': movieId,
      'movieTitle': movieTitle,
      'posterPath': posterPath,
      'starRating': starRating,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'viewingDate': viewingDate.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Review {id: $id, content: $content}';
  }
}

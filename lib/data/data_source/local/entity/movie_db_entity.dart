import 'package:movie_search/domain/model/movie/movie.dart';

class MovieDbEntity {
  final String uid;
  final int id;
  final String title;
  final String? posterPath;
  final String? backdropPath;
  final int adult;
  final String genreIds;
  final String originalLanguage;
  final String originalTitle;
  final String overview;
  final double popularity;
  final String? releaseDate;
  final int video;
  final double voteAverage;
  final int voteCount;
  final int bookmarkTime;

  MovieDbEntity({
    required this.uid,
    required this.id,
    required this.title,
    required this.posterPath,
    required this.backdropPath,
    required this.bookmarkTime,
    required this.video,
    required this.voteAverage,
    required this.originalTitle,
    required this.voteCount,
    required this.overview,
    required this.adult,
    required this.genreIds,
    required this.originalLanguage,
    required this.popularity,
    required this.releaseDate,
  });

  factory MovieDbEntity.fromMovie(Movie movie, String uid) {
    return MovieDbEntity(
      uid: uid,
      title: movie.title,
      id: movie.id,
      posterPath: movie.posterPath,
      backdropPath: movie.backdropPath,
      video: movie.video ? 1 : 0,
      adult: movie.adult ? 1 : 0,
      genreIds: movie.genreIds.join(','),
      originalLanguage: movie.originalLanguage,
      originalTitle: movie.originalTitle,
      overview: movie.overview,
      popularity: movie.popularity,
      releaseDate: movie.releaseDate,
      voteAverage: movie.voteAverage,
      voteCount: movie.voteCount,
      bookmarkTime: DateTime.now().millisecondsSinceEpoch,
    );
  }

  factory MovieDbEntity.fromJson(Map<String, dynamic> json) {
    return MovieDbEntity(
      uid: json['uid'] as String,
      id: json['id'] as int,
      title: json['title'] as String,
      posterPath: json['posterPath'] as String?,
      backdropPath: json['backdropPath'] as String?,
      bookmarkTime: json['bookmarkTime'] as int,
      adult: json['adult'] as int,
      video: json['video'] as int,
      genreIds: json['genreIds'] as String,
      originalLanguage: json['originalLanguage'] as String,
      originalTitle: json['originalTitle'] as String,
      overview: json['overview'] as String,
      popularity: json['popularity'] as double,
      releaseDate: json['releaseDate'] as String,
      voteAverage: json['voteAverage'] as double,
      voteCount: json['voteCount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'backdropPath': backdropPath,
      'video': video,
      'voteAverage': voteAverage,
      'originalTitle': originalTitle,
      'voteCount': voteCount,
      'overview': overview,
      'adult': adult,
      'genreIds': genreIds,
      'originalLanguage': originalLanguage,
      'popularity': popularity,
      'releaseDate': releaseDate,
      'bookmarkTime': bookmarkTime,
    };
  }

  Movie toMovie() {
    return Movie(
      adult: adult == 1 ? true : false,
      backdropPath: backdropPath,
      genreIds: genreIds.split(',').map((e) => int.parse(e)).toList(),
      id: id,
      originalLanguage: originalLanguage,
      originalTitle: originalTitle,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      releaseDate: releaseDate,
      title: title,
      video: video == 1 ? true : false,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }

  @override
  String toString() {
    return 'MovieDbEntity{id: $id}';
  }

  String toRawValues() {
    return '("$uid", $id, "$title", "$posterPath", "$backdropPath", $adult, "$genreIds", "$originalLanguage", "$originalTitle", "$overview", $popularity, $popularity, "$releaseDate", $video, $voteAverage, $voteCount, $bookmarkTime)';
  }
}

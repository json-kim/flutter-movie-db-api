import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/entity/genre/genre.dart';

part 'movie_detail.freezed.dart';
part 'movie_detail.g.dart';

@freezed
class MovieDetail with _$MovieDetail {
  const factory MovieDetail({
    required bool adult,
    @JsonKey(name: 'backdrop_path') required String? backdropPath,
    @JsonKey(name: 'belongs_to_collection')
        required Collection? belongsToCollection,
    required int budget,
    required List<Genre> genres,
    required String? homepage,
    required int id,
    @JsonKey(name: 'imdb_id') required String? imdbId,
    @JsonKey(name: 'original_language') required String originalLanguage,
    @JsonKey(name: 'original_title') required String originalTitle,
    required String? overview,
    required double popularity,
    @JsonKey(name: 'poster_path') required String? posterPath,
    @JsonKey(name: 'release_date') required String releaseDate,
    required int revenue,
    required int? runtime,
    required String status,
    required String? tagline,
    required String title,
    required bool video,
    @JsonKey(name: 'vote_average') required double voteAverage,
    @JsonKey(name: 'vote_count') required int voteCount,
  }) = _MovieDetail;

  factory MovieDetail.fromJson(Map<String, dynamic> json) =>
      _$MovieDetailFromJson(json);
}

class Collection {
  final int id;
  final String name;
  final String? posterPath;
  final String? backdropPath;

  Collection(
      {required this.id,
      required this.name,
      required this.posterPath,
      required this.backdropPath});

  factory Collection.fromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'] as int,
      name: json['name'] as String,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'poster_path': posterPath,
        'backdrop_path': backdropPath,
      };
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'genre.freezed.dart';
part 'genre.g.dart';

@freezed
class Genre with _$Genre {
  const factory Genre({
    required String name,
    required int id,
  }) = _Genre;

  factory Genre.fromJson(Map<String, dynamic> json) => _$GenreFromJson(json);
}

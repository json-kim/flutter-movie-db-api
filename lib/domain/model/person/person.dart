import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';
part 'person.g.dart';

@freezed
class Person with _$Person {
  const factory Person({
    required bool adult,
    @JsonKey(name: 'also_known_as') required List<String> alsoKnownAs,
    required String biography,
    required String? birthday,
    required String? deathday,
    required int gender,
    required String? homepage,
    required int id,
    @JsonKey(name: 'imdb_id') required String imdbId,
    @JsonKey(name: 'known_for_department') required String knownForDepartment,
    required String name,
    @JsonKey(name: 'place_of_birth') required String? placeOfBirth,
    required double popularity,
    @JsonKey(name: 'profile_path') required String? profilePath,
  }) = _Person;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
}

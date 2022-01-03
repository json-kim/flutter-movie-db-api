import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';
part 'person.g.dart';

@freezed
class Person with _$Person {
  const factory Person({
    required bool adult,
    required List<String> alsoKnownAs,
    required String? biography,
    required String birthday,
    required String? deathday,
    required int gender,
    required String? homepage,
    required int id,
    required String imdbId,
    required String knownForDepartment,
    required String name,
    required String? placeOfBirth,
    required double popularity,
    required String? profilePath,
  }) = _Person;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
}

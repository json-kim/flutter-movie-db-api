import 'package:movie_search/domain/model/person/person.dart';

class PersonDbEntity {
  final int id;
  final int gender;
  final String? deathday;
  final String? birthday;
  final String biography;
  final String? homepage;
  final String imdbId;
  final String knownForDepartment;
  final String name;
  final String? placeOfBirth;
  final double popularity;
  final String? profilePath;
  final int adult;
  final String alsoKnownAs;

  PersonDbEntity({
    required this.id,
    required this.gender,
    required this.deathday,
    required this.birthday,
    required this.biography,
    required this.homepage,
    required this.imdbId,
    required this.knownForDepartment,
    required this.name,
    required this.placeOfBirth,
    required this.popularity,
    required this.profilePath,
    required this.adult,
    required this.alsoKnownAs,
  });

  factory PersonDbEntity.fromPerson(Person person) {
    return PersonDbEntity(
      id: person.id,
      gender: person.gender,
      deathday: person.deathday,
      birthday: person.birthday,
      biography: person.biography,
      homepage: person.homepage,
      imdbId: person.imdbId,
      knownForDepartment: person.knownForDepartment,
      name: person.name,
      placeOfBirth: person.placeOfBirth,
      popularity: person.popularity,
      profilePath: person.profilePath,
      adult: person.adult ? 1 : 0,
      alsoKnownAs: person.alsoKnownAs.join(','),
    );
  }

  factory PersonDbEntity.fromJson(Map<String, dynamic> json) {
    return PersonDbEntity(
      id: json['id'] as int,
      gender: json['gender'] as int,
      deathday: json['deathday'] as String?,
      birthday: json['birthday'] as String?,
      biography: json['biography'] as String,
      homepage: json['homepage'] as String?,
      imdbId: json['imdbId'] as String,
      knownForDepartment: json['knownForDepartment'] as String,
      name: json['name'] as String,
      placeOfBirth: json['placeOfBirth'] as String?,
      popularity: json['popularity'] as double,
      profilePath: json['profilePath'] as String?,
      adult: json['adult'] as int,
      alsoKnownAs: json['alsoKnownAs'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gender': gender,
      'deathday': deathday,
      'birthday': birthday,
      'biography': biography,
      'homepage': homepage,
      'imdbId': imdbId,
      'knownForDepartment': knownForDepartment,
      'name': name,
      'placeOfBirth': placeOfBirth,
      'popularity': popularity,
      'profilePath': profilePath,
      'adult': adult,
      'alsoKnownAs': alsoKnownAs,
    };
  }

  Person toPerson() {
    return Person(
      id: id,
      gender: gender,
      deathday: deathday,
      birthday: birthday,
      biography: biography,
      homepage: homepage,
      imdbId: imdbId,
      knownForDepartment: knownForDepartment,
      name: name,
      placeOfBirth: placeOfBirth,
      popularity: popularity,
      profilePath: profilePath,
      adult: adult == 1 ? true : false,
      alsoKnownAs: alsoKnownAs.split(','),
    );
  }

  @override
  String toString() {
    return '{PersonDbEntity : $id}';
  }

  String toRawValues() {
    return '($id, $gender, "$deathday", "$birthday", "$biography", "$homepage", "$imdbId", "$knownForDepartment", "$name", "$placeOfBirth", $popularity, "$profilePath", $adult, "$alsoKnownAs")';
  }
}

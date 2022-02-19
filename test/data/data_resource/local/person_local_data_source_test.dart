import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/data/data_source/local/entity/person_db_entity.dart';
import 'package:movie_search/data/data_source/local/person_local_data_source.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('인물 로컬 데이터소스 테스트', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

    await db.execute('''
      CREATE TABLE person(
      id INTEGER PRIMARY KEY,
      gender INTEGER NOT NULL,
      deathday TEXT,
      birthday TEXT,
      biography TEXT NOT NULL,
      homepage TEXT,
      imdbId TEXT NOT NULL,
      knownForDepartment TEXT NOT NULL,
      name TEXT NOT NULL,
      placeOfBirth TEXT,
      popularity REAL NOT NULL,
      profilePath TEXT,
      adult INTEGER NOT NULL,
      alsoKnownAs NOT NULL
      )
      ''');

    final localDataSource = PersonLocalDataSource(db);

    final person = Person.fromJson(jsonDecode(fakeJson));
    final personDbEntity = PersonDbEntity.fromPerson(person);
  });
}

const fakeJson = '''
{
    "adult": false,
    "also_known_as": [
        "برد پیت",
        "Бред Пітт",
        "Брэд Питт",
        "畢·彼特",
        "ブラッド・ピット",
        "브래드 피트",
        "براد بيت",
        "แบรด พิตต์",
        "William Bradley \"Brad\" Pitt",
        "William Bradley Pitt",
        "Μπραντ Πιτ",
        "布拉德·皮特",
        "Breds Pits",
        "ബ്രാഡ് പിറ്റ് "
    ],
    "biography": "",
    "birthday": "1963-12-18",
    "deathday": null,
    "gender": 2,
    "homepage": null,
    "id": 287,
    "imdb_id": "nm0000093",
    "known_for_department": "Acting",
    "name": "Brad Pitt",
    "place_of_birth": "Shawnee, Oklahoma, USA",
    "popularity": 29.007,
    "profile_path": "/oTB9vGIBacH5aQNS0pUM74QSWuf.jpg"
}
''';

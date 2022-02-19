import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/data/data_source/local/entity/review_db_entity.dart';
import 'package:movie_search/data/data_source/local/review_local_data_source.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('리뷰 로컬 데이터소스를 테스트합니다.', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

    db.execute('''
    CREATE TABLE review(
    id TEXT PRIMARY KEY,
    movieId INTEGER NOT NULL,
    starRating REAL NOT NULL,
    content TEXT NOT NULL,
    createdAt TEXT NOT NULL,
    viewingDate TEXT NOT NULL
    )
    ''');

    final localDataSource = ReviewLocalDataSource(db);

    final entity = ReviewDbEntity.fromJson(jsonDecode(fakeJson));

    final result = await localDataSource.insertReview(entity);

    result.when(success: (result) {
      expect(result, 1);
    }, error: (message) {
      print(message);
    });

    final getResult = await localDataSource.getReviewByMovie(123432);

    getResult.when(success: (review) {
      expect(review.id, "testId");
    }, error: (message) {
      print(message);
    });
  });
}

const fakeJson = '''
{
  "id": "testId",
  "movieId": 123432,
  "starRating": 3,
  "content": "영화 재밌습니다.",
  "createdAt": "2022-02-02",
  "viewingDate": "2022-01-01"
}
''';

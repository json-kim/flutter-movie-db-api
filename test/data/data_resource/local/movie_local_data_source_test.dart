import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/data/data_source/local/entity/movie_db_entity.dart';
import 'package:movie_search/data/data_source/local/movie_local_data_source.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('로컬 영화 db 테스트합니다.', () async {
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);

    await db.execute('''
      CREATE TABLE movie(
      id INTEGER PRIMARY KEY,
      title TEXT NOT NULL,
      posterPath TEXT,
      backdropPath TEXT,
      adult INTEGER NOT NULL,
      genreIds TEXT,
      originalLanguage TEXT,
      originalTitle TEXT,
      overview TEXT,
      popularity REAL,
      releaseDate TEXT,
      video INTEGER,
      voteAverage REAL,
      voteCount INTEGER,
      bookmarkTime INTEGER
      )
      ''');

    final localDataSource = MovieLocalDataSource(db);

    final movie = Movie.fromJson(jsonDecode(fakeJson));
    final movieDbEntity = MovieDbEntity.fromMovie(movie);

    final result = await localDataSource.insertMovie(movieDbEntity);

    result.when(
      success: (movieId) async {
        print(movieId);
      },
      error: (message) {
        print(message);
      },
    );

    final movieResult = await localDataSource.getMovieById(524434);
    movieResult.when(success: (entity) {
      print(entity);
      expect(entity.toMovie(), movie);
    }, error: (message) {
      print(message);
    });

    final delResult = await localDataSource.deleteMovie(524434);

    delResult.when(
      success: (del) {
        print(del);
        expect(del, 1);
      },
      error: (message) {
        print(message);
      },
    );

    // getMovies 테스트
    final loadListResult = await localDataSource.getMovies(1);

    loadListResult.when(success: (entities) {
      expect(entities, []);
    }, error: (message) {
      print(message);
    });
  });
}

const fakeJson = '''
{
            "adult": false,
            "backdrop_path": "/k2twTjSddgLc1oFFHVibfxp2kQV.jpg",
            "genre_ids": [
                28,
                12,
                14,
                878
            ],
            "id": 524434,
            "original_language": "en",
            "original_title": "Eternals",
            "overview": "이터널스는 7천년 전 우주선 도모를 타고 지구에 온 순간부터 지구를 사랑한 히어로들이다. 이들의 임무는 기괴한 크리처 데비안츠에게서 인간을 지키는 것. 임무를 부여한 이는 그들을 탄생시킨 천상의 존재 셀레스티얼이다. 이터널스는 시간의 흐름을 느낄 수 없기에, 공간을 기준 삼아 연대기를 구성하는 뱀파이어처럼 세계 곳곳에 흩어져 자신만의 삶을 살아가고 있다. 물질을 변화시키는 세르시(제마 챈)는 런던에서 박물관 학자가 됐고, 우주의 기운을 총처럼 쏘는 킹고(쿠마일 난지아니)는 발리우드 배우로 살며, 타인을 조종하는 드루이그(배리 키오건)는 아마존에 소국을 만들었다. 괴력의 소유자 길가메시(마동석)는 호주 사막에서 정신 건강이 위험해진 테나(안젤리나 졸리)를 돌보며 살고 있다. 세르시는 데비안츠의 공세가 심해지자 오랜 연인 이카리스(리처드 매든), 소녀처럼 보이는 불멸의 존재 스프라이트(리아 맥휴)와 함께 이터널스를 불러모으기 시작한다.",
            "popularity": 10950.444,
            "poster_path": "/aNtAP8ZzUMdnCPoqYgVOcgI0Eh4.jpg",
            "release_date": "2021-11-03",
            "title": "이터널스",
            "video": false,
            "vote_average": 7.3,
            "vote_count": 3308
        }
''';

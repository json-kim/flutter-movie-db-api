import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_search/core/error/auth_exception.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/local/entity/movie_db_entity.dart';
import 'package:sqflite/sqflite.dart';

class MovieLocalDataSource {
  final Database _db;

  MovieLocalDataSource(this._db);

  String _getUid() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw BaseException('currentuser is null login is needed');
    }

    return currentUser.uid;
  }

  /// db에서 아이디를 가지고 영화정보 가져오기기
  Future<Result<MovieDbEntity>> getMovieById(int id) async {
    try {
      final List<Map<String, dynamic>> maps = await _db.query('movie',
          where: 'uid = ? and id = ?', whereArgs: [_getUid(), id]);

      if (maps.isNotEmpty) {
        return Result.success(MovieDbEntity.fromJson(maps.first));
      } else {
        return Result.error('$runtimeType : getMovieById - 영화를 찾을 수 없습니다.');
      }
    } catch (e) {
      return Result.error(
          '$runtimeType : getMovieById 에러 발생 \n${e.toString()}');
    }
  }

  /// db에서 영화리스트 가져오기
  Future<Result<List<MovieDbEntity>>> getMovies(int page) async {
    try {
      final List<Map<String, dynamic>> maps = await _db.query('movie',
          offset: (page - 1) * 20,
          limit: 20,
          where: 'uid = ?',
          whereArgs: [_getUid()]);

      if (maps.isNotEmpty) {
        final List<MovieDbEntity> entities =
            maps.map((e) => MovieDbEntity.fromJson(e)).toList();
        return Result.success(entities);
      } else {
        return Result.success([]);
      }
    } catch (e) {
      return Result.error('$runtimeType : getMovies 에러 발생 \n${e.toString()}');
    }
  }

  /// db에 저장된 영화의 개수 가져오기
  Future<int> getCountMovies() async {
    final result = await _db
        .rawQuery('SELECT COUNT(*) FROM movie WHERE uid = "${_getUid()}"');
    final count = Sqflite.firstIntValue(result);

    return count ?? 0;
  }

  /// db에서 모든 영화 가져오기
  Future<Result<List<MovieDbEntity>>> getAllMovies() async {
    try {
      final List<Map<String, dynamic>> maps =
          await _db.query('movie', where: 'uid = ?', whereArgs: [_getUid()]);

      if (maps.isNotEmpty) {
        final List<MovieDbEntity> entities =
            maps.map((e) => MovieDbEntity.fromJson(e)).toList();
        return Result.success(entities);
      } else {
        return Result.success([]);
      }
    } catch (e) {
      return Result.error(
          '$runtimeType : getAllMovies 에러 발생 \n${e.toString()}');
    }
  }

  /// db에 영화 저장하기
  Future<Result<int>> insertMovie(MovieDbEntity movie) async {
    try {
      final result = await _db.insert('movie', movie.toJson());

      if (result == 0) {
        return Result.error(
            '$runtimeType : insertMovie 에러 발생 \n데이터 삽입에 실패했습니다.');
      }
      return Result.success(result);
    } catch (e) {
      return Result.error('$runtimeType : insertMovie 에러 발생 \n${e.toString()}');
    }
  }

  /// db에서 영화 삭제하기
  Future<Result<int>> deleteMovie(int id) async {
    try {
      final result = await _db.delete('movie',
          where: 'uid = ? and id = ?', whereArgs: [_getUid(), id]);

      if (result < 1) {
        return Result.error(
            '$runtimeType : deleteMovie 에러 발생 \n해당 아이디를 가진 영화가 없습니다.');
      }
      return Result.success(result);
    } catch (e) {
      return Result.error('$runtimeType : deleteMovie 에러 발생 \n${e.toString()}');
    }
  }

  /// db 전부 삭제
  Future<Result<void>> deleteAllMovies() async {
    await _db.delete('movie');

    return Result.success(null);
  }

  /// 백업 데이터로 db 초기화
  Future<Result<void>> restoreMovies(List<MovieDbEntity> movies) async {
    final batch = _db.batch();
    batch.delete('movie');

    if (movies.isNotEmpty) {
      final valueString =
          movies.map((entity) => entity.toRawValues()).join(',');
      batch.rawInsert('''
      INSERT INTO movie
        (uid, id, title, posterPath, backdropPath, adult, genreIds, originalLanguage, originalTitle, overview, popularity, popularity, releaseDate, video, voteAverage, voteCount, bookmarkTime)
      VALUES
        $valueString
      ''');
    }

    await batch.commit();

    return Result.success(null);
  }
}

import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/local/entity/movie_db_entity.dart';
import 'package:sqflite/sqflite.dart';

class MovieLocalDataSource {
  final Database _db;

  MovieLocalDataSource(this._db);

  // db에서 아이디를 가지고 영화정보 가져오기기
  Future<Result<MovieDbEntity>> getMovieById(int id) async {
    try {
      final List<Map<String, dynamic>> maps =
          await _db.query('movie', where: 'id = ?', whereArgs: [id]);

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

  // db에서 영화리스트 가져오기
  Future<Result<List<MovieDbEntity>>> getMovies(int page) async {
    try {
      final List<Map<String, dynamic>> maps =
          await _db.query('movie', offset: (page - 1) * 20, limit: 20);

      if (maps.isNotEmpty) {
        final List<MovieDbEntity> entities =
            maps.map((e) => MovieDbEntity.fromJson(e)).toList();
        return Result.success(entities);
      } else {
        return Result.error('$runtimeType : getMovies 에러 발생 - 저장된 영화가 없습니다.');
      }
    } catch (e) {
      return Result.error('$runtimeType : getMovies 에러 발생 \n${e.toString()}');
    }
  }

  // db에 영화 저장하기
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

  // db에서 영화 삭제하기
  Future<Result<int>> deleteMovie(int id) async {
    try {
      final result =
          await _db.delete('movie', where: 'id = ?', whereArgs: [id]);

      if (result < 1) {
        return Result.error(
            '$runtimeType : deleteMovie 에러 발생 \n해당 아이디를 가진 영화가 없습니다.');
      }
      return Result.success(result);
    } catch (e) {
      return Result.error('$runtimeType : deleteMovie 에러 발생 \n${e.toString()}');
    }
  }
}

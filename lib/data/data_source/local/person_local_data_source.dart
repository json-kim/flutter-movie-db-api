import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/local/entity/person_db_entity.dart';
import 'package:sqflite/sqflite.dart';

class PersonLocalDataSource {
  Database _db;

  PersonLocalDataSource(this._db);

  // db에서 아이디를 가지고 인물정보 가져오기기
  Future<Result<PersonDbEntity>> getPersonById(int id) async {
    try {
      final List<Map<String, dynamic>> maps =
          await _db.query('person', where: 'id = ?', whereArgs: [id]);

      if (maps.isNotEmpty) {
        return Result.success(PersonDbEntity.fromJson(maps.first));
      } else {
        return Result.error('$runtimeType : getPersonById - 인물을 찾을 수 없습니다.');
      }
    } catch (e) {
      return Result.error(
          '$runtimeType : getPersonById 에러 발생 \n${e.toString()}');
    }
  }

  // db에서 인물리스트 가져오기
  Future<Result<List<PersonDbEntity>>> getPersons(int page) async {
    try {
      final List<Map<String, dynamic>> maps =
          await _db.query('person', offset: (page - 1) * 20, limit: 20);

      if (maps.isNotEmpty) {
        final List<PersonDbEntity> entities =
            maps.map((e) => PersonDbEntity.fromJson(e)).toList();
        return Result.success(entities);
      } else {
        return Result.error('$runtimeType : getPersons 에러 발생 - 저장된 인물이 없습니다.');
      }
    } catch (e) {
      return Result.error('$runtimeType : getPersons 에러 발생 \n${e.toString()}');
    }
  }

  // db에 인물 저장하기
  Future<Result<int>> insertPerson(PersonDbEntity person) async {
    try {
      final result = await _db.insert('person', person.toJson());

      if (result == 0) {
        return Result.error(
            '$runtimeType : insertPerson 에러 발생 \n데이터 삽입에 실패했습니다.');
      }
      return Result.success(result);
    } catch (e) {
      return Result.error(
          '$runtimeType : insertPerson 에러 발생 \n${e.toString()}');
    }
  }

  // db에서 인물 삭제하기
  Future<Result<int>> deletePerson(int id) async {
    try {
      final result =
          await _db.delete('person', where: 'id = ?', whereArgs: [id]);

      if (result < 1) {
        return Result.error(
            '$runtimeType : deletePerson 에러 발생 \n해당 아이디를 가진 인물이 없습니다.');
      }
      return Result.success(result);
    } catch (e) {
      return Result.error(
          '$runtimeType : deletePerson 에러 발생 \n${e.toString()}');
    }
  }
}

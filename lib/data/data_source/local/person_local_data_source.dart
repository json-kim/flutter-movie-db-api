import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_search/core/error/auth_exception.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/local/entity/person_db_entity.dart';
import 'package:sqflite/sqflite.dart';

class PersonLocalDataSource {
  Database _db;

  PersonLocalDataSource(this._db);

  String _getUid() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw BaseException('currentuser is null login is needed');
    }

    return currentUser.uid;
  }

  /// db에서 아이디를 가지고 인물정보 가져오기기
  Future<Result<PersonDbEntity>> getPersonById(int id) async {
    try {
      final List<Map<String, dynamic>> maps = await _db.query('person',
          where: 'uid = ? and id = ?', whereArgs: [_getUid(), id]);

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

  /// db에서 인물리스트 가져오기
  Future<Result<List<PersonDbEntity>>> getPersons(int page) async {
    try {
      final List<Map<String, dynamic>> maps = await _db.query('person',
          offset: (page - 1) * 20,
          limit: 20,
          where: 'uid = ?',
          whereArgs: [_getUid()]);

      if (maps.isNotEmpty) {
        final List<PersonDbEntity> entities =
            maps.map((e) => PersonDbEntity.fromJson(e)).toList();
        return Result.success(entities);
      } else {
        return Result.success([]);
      }
    } catch (e) {
      return Result.error('$runtimeType : getPersons 에러 발생 \n${e.toString()}');
    }
  }

  /// db에서 모든 인물정보 가져오기
  Future<Result<List<PersonDbEntity>>> getAllPersons() async {
    try {
      final List<Map<String, dynamic>> maps =
          await _db.query('person', where: 'uid = ?', whereArgs: [_getUid()]);

      if (maps.isNotEmpty) {
        final List<PersonDbEntity> entities =
            maps.map((e) => PersonDbEntity.fromJson(e)).toList();
        return Result.success(entities);
      } else {
        return Result.success([]);
      }
    } catch (e) {
      return Result.error(
          '$runtimeType : getAllPersons 에러 발생 \n${e.toString()}');
    }
  }

  /// db에 저장된 인물의 개수 가져오기
  Future<int> getCountPersons() async {
    final result = await _db
        .rawQuery('SELECT COUNT(*) FROM person WHERE uid = "${_getUid()}"');
    final count = Sqflite.firstIntValue(result);

    return count ?? 0;
  }

  /// db에 인물 저장하기
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

  /// db에서 인물 삭제하기
  Future<Result<int>> deletePerson(int id) async {
    try {
      final result = await _db.delete('person',
          where: 'uid = ? and id = ?', whereArgs: [_getUid(), id]);

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

  /// db 전부 삭제
  Future<Result<void>> deleteAllPersons() async {
    await _db.delete('person');

    return Result.success(null);
  }

  /// 백업 데이터로 db 초기화
  Future<Result<void>> restorePersons(List<PersonDbEntity> persons) async {
    final batch = _db.batch();
    batch.delete('person');

    if (persons.isNotEmpty) {
      final valueString =
          persons.map((entity) => entity.toRawValues()).join(',');
      batch.rawInsert('''
      INSERT INTO person
        (uid, id, gender, deathday, birthday, biography, homepage, imdbId, knownForDepartment, name, placeOfBirth, popularity, profilePath, adult, alsoKnownAs)
      VALUES
        $valueString
      ''');
    }

    await batch.commit();

    return Result.success(null);
  }
}

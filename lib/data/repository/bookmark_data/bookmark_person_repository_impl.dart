import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_search/core/error/auth_exception.dart';
import 'package:movie_search/core/page/page.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/local/entity/person_db_entity.dart';
import 'package:movie_search/data/data_source/local/person_local_data_source.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/repository/bookmark_data_repository.dart';

class BookmarkPersonRepositoryImpl
    implements BookmarkDataRepository<Person, int> {
  final PersonLocalDataSource _dataSource;

  BookmarkPersonRepositoryImpl(this._dataSource);

  String _getUid() {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      throw BaseException('currentuser is null login is needed');
    }

    return currentUser.uid;
  }

  @override
  Future<Result<int>> deleteData(int personId) async {
    final result = await _dataSource.deletePerson(personId);

    return result.when(success: (delResult) {
      return Result.success(delResult);
    }, error: (message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<Person>> loadData(int personId) async {
    final result = await _dataSource.getPersonById(personId);

    return result.when(success: (entity) {
      try {
        final Person person = entity.toPerson();
        return Result.success(person);
      } catch (e) {
        return Result.error(
            '$runtimeType.loadData : entity => Person 파싱 에러 발생 \n$e');
      }
    }, error: (message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<Page<Person>>> loadDataList(int page) async {
    final count = await _dataSource.getCountPersons();
    final totalPage = count ~/ 20 + 1;
    final result = await _dataSource.getPersons(page);

    return result.when(success: (entityList) {
      try {
        final List<Person> personList =
            entityList.map((entity) => entity.toPerson()).toList();

        return Result.success(Page<Person>(
          currentPage: page,
          lastPage: totalPage,
          items: personList,
        ));
      } catch (e) {
        return Result.error(
            '$runtimeType.loadDataList : entity => Person 파싱 에러 발생\n$e');
      }
    }, error: (message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<int>> saveData(Person data) async {
    try {
      final PersonDbEntity entity = PersonDbEntity.fromPerson(data, _getUid());

      final result = await _dataSource.insertPerson(entity);

      return result.when(success: (saveResult) {
        return Result.success(saveResult);
      }, error: (message) {
        return Result.error(message);
      });
    } catch (e) {
      return Result.error(
          '$runtimeType.saveData : Person => entity 파싱 에러 발생 \n$e');
    }
  }

  @override
  Future<Result<List<Person>>> loadAllDatas() async {
    final result = await _dataSource.getAllPersons();

    return result.when(success: (entityList) {
      try {
        final List<Person> personList =
            entityList.map((entity) => entity.toPerson()).toList();

        return Result.success(personList);
      } catch (e) {
        return Result.error(
            '$runtimeType.loadAllDatas : entity => Person 파싱 에러 발생\n$e');
      }
    }, error: (message) {
      return Result.error(message);
    });
  }

  @override
  Future<Result<void>> restoreDatas(List<Person> datas) async {
    final uid = _getUid();
    final entities =
        datas.map((person) => PersonDbEntity.fromPerson(person, uid)).toList();

    final result = await _dataSource.restorePersons(entities);

    return result.when(
      success: (restoreResult) {
        return Result.success(restoreResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<void>> deleteAll() async {
    final result = await _dataSource.deleteAllPersons();

    return result.when(
      success: (_) {
        return Result.success(null);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}

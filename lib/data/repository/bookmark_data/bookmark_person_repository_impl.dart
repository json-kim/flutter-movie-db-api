import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/local/entity/person_db_entity.dart';
import 'package:movie_search/data/data_source/local/person_local_data_source.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/repository/bookmark_data_repository.dart';

class BookmarkPersonRepositoryImpl
    implements BookmarkDataRepository<Person, int> {
  final PersonLocalDataSource _dataSource;

  BookmarkPersonRepositoryImpl(this._dataSource);

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
  Future<Result<List<Person>>> loadDataList(int page) async {
    final result = await _dataSource.getPersons(page);

    return result.when(success: (entityList) {
      try {
        final List<Person> personList =
            entityList.map((entity) => entity.toPerson()).toList();

        return Result.success(personList);
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
      final PersonDbEntity entity = PersonDbEntity.fromPerson(data);

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
}

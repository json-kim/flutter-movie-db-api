import 'dart:convert';

import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

class PersonDataRepositoryImpl implements MovieDataRepository<Person, Param> {
  final MovieRemoteDataSource _remoteDataSource;

  PersonDataRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<Person>> fetch(Param param) async {
    final result = await _remoteDataSource.fetch(param);

    return result.when(success: (jsonBody) {
      final jsonResult = jsonDecode(jsonBody);
      final person = Person.fromJson(jsonResult);
      return Result.success(person);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

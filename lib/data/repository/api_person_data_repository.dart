import 'dart:convert';

import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/data/data_source/remote/tmdb_api.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

class ApiPersonDataRepository
    implements MovieDataRepository<Person, RequestParams> {
  final TMDBApi tmdbApi;

  ApiPersonDataRepository(this.tmdbApi);

  @override
  Future<Result<List<Person>>> fetch(RequestParams params) async {
    final url = changeParamsToPath(params);
    final result = await tmdbApi.fetch(url);

    return result.when(success: (jsonBody) {
      final jsonResult = jsonDecode(jsonBody);
      final person = Person.fromJson(jsonResult);
      return Result.success([person]);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

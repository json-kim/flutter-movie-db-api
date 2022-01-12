import 'dart:convert';

import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/data/data_source/tmdb_api.dart';
import 'package:movie_search/domain/model/credit/credit.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

class ApiCreditDataRepository
    implements MovieDataRepository<Credit, RequestParams> {
  final TMDBApi tmdbApi;

  ApiCreditDataRepository(this.tmdbApi);

  @override
  Future<Result<List<Credit>>> fetch(RequestParams params) async {
    final url = changeParamsToPath(params);
    final result = await tmdbApi.fetch(url);

    return result.when(success: (jsonBody) {
      final List jsonCast = jsonDecode(jsonBody)['cast'];
      final List<Credit> credits =
          jsonCast.map((e) => Credit.fromJson(e)).toList();
      return Result.success(credits);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

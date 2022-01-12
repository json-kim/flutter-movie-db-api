import 'dart:convert';

import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/data/data_source/tmdb_api.dart';
import 'package:movie_search/domain/model/keyword/keyword.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

class ApiKeywordDataRepository
    implements MovieDataRepository<Keyword, RequestParams> {
  final TMDBApi tmdbApi;

  ApiKeywordDataRepository(this.tmdbApi);

  @override
  Future<Result<List<Keyword>>> fetch(RequestParams params) async {
    final url = changeParamsToPath(params);
    final result = await tmdbApi.fetch(url);

    return result.when(success: (jsonBody) {
      final List jsonKeywords = jsonDecode(jsonBody)['keywords'];
      final List<Keyword> keywords =
          jsonKeywords.map((e) => Keyword.fromJson(e)).toList();
      return Result.success(keywords);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

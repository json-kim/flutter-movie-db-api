import 'dart:convert';

import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/data/data_source/tmdb_api.dart';
import 'package:movie_search/domain/model/genre/genre.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

class ApiGenreDataRepository
    implements MovieDataRepository<Genre, RequestParams> {
  final TMDBApi tmdbApi;

  ApiGenreDataRepository(this.tmdbApi);

  @override
  Future<Result<List<Genre>>> fetch(RequestParams params) async {
    String url = changeParamsToPath(params);
    final result = await tmdbApi.fetch(url);

    return result.when(success: (jsonBody) {
      final List jsonGenres = jsonDecode(jsonBody)['genres'];
      final List<Genre> genres =
          jsonGenres.map((e) => Genre.fromJson(e)).toList();
      return Result.success(genres);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

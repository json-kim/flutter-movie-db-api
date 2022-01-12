import 'dart:convert';

import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/data/data_source/tmdb_api.dart';
import 'package:movie_search/domain/model/cast/cast.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

class ApiCastDataRepository
    implements MovieDataRepository<Cast, RequestParams> {
  final TMDBApi _tmdbApi;

  ApiCastDataRepository(this._tmdbApi);

  @override
  Future<Result<List<Cast>>> fetch(RequestParams params) async {
    final url = changeParamsToPath(params);
    final result = await _tmdbApi.fetch(url);

    return result.when(success: (jsonBody) {
      final List jsonCast = jsonDecode(jsonBody)['cast'];
      final List<Cast> casts = jsonCast.map((e) => Cast.fromJson(e)).toList();

      return Result.success(casts);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

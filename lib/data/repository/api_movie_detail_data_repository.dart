import 'dart:convert';

import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/data/data_source/tmdb_api.dart';
import 'package:movie_search/domain/model/movie_detail/movie_detail.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

class ApiMovieDetailDataRepository
    implements MovieDataRepository<MovieDetail, RequestParams> {
  final TMDBApi tmdbApi;

  ApiMovieDetailDataRepository(this.tmdbApi);

  @override
  Future<Result<List<MovieDetail>>> fetch(RequestParams params) async {
    final url = changeParamsToPath(params);
    final result = await tmdbApi.fetch(url);

    return result.when(success: (jsonBody) {
      final Map<String, dynamic> jsonResult = jsonDecode(jsonBody);
      final movieDetail = MovieDetail.fromJson(jsonResult);

      return Result.success([movieDetail]);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

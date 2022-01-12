import 'dart:convert';

import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/data/data_source/tmdb_api.dart';
import 'package:movie_search/domain/model/video/video.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

class ApiVideoDataRepository
    implements MovieDataRepository<Video, RequestParams> {
  final TMDBApi tmdbApi;

  ApiVideoDataRepository(this.tmdbApi);

  @override
  Future<Result<List<Video>>> fetch(RequestParams params) async {
    final url = changeParamsToPath(params);
    final result = await tmdbApi.fetch(url);

    return result.when(success: (jsonBody) {
      final List jsonResult = jsonDecode(jsonBody)['results'];
      final List<Video> videos =
          jsonResult.map((e) => Video.fromJson(e)).toList();
      return Result.success(videos);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

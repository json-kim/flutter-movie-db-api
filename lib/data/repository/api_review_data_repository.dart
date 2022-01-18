import 'dart:convert';

import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/data/data_source/remote/tmdb_api.dart';
import 'package:movie_search/domain/model/review/review.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

class ApiReviewDataRepository
    implements MovieDataRepository<Review, RequestParams> {
  final TMDBApi tmdbApi;

  ApiReviewDataRepository(this.tmdbApi);

  @override
  Future<Result<List<Review>>> fetch(RequestParams params) async {
    final url = changeParamsToPath(params);
    final result = await tmdbApi.fetch(url);

    return result.when(success: (jsonBody) {
      final List jsonResult = jsonDecode(jsonBody)['results'];
      final List<Review> reviews =
          jsonResult.map((e) => Review.fromJson(e)).toList();
      return Result.success(reviews);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';

abstract class MovieDataRepository<T, P extends RequestParams> {
  Future<Result<List<T>>> fetch(P params);
}

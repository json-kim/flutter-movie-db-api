import 'package:movie_search/core/util/constants.dart';

class RequestParams {
  final String apiKey;
  final String language;

  RequestParams({
    this.apiKey = kApiKey,
    this.language = 'ko-KR',
  });
}

class RequestParamsWithGenre extends RequestParams {
  final String genreId;
  final int page;

  RequestParamsWithGenre({
    required this.genreId,
    this.page = 1,
  }) : super();
}

class RequestParamsWithQuery extends RequestParams {
  final String query;
  final int page;

  RequestParamsWithQuery({
    required this.query,
    this.page = 1,
  }) : super();
}

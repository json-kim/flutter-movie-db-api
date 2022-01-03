import 'package:movie_search/core/util/constants.dart';

class RequestParams {
  final String apiKey;
  final String language;
  final String pathParams;

  RequestParams({
    this.apiKey = kApiKey,
    this.language = 'ko-KR',
    required this.pathParams,
  });
}

class RequestParamsWithPage extends RequestParams {
  final int page;

  RequestParamsWithPage({
    this.page = 1,
    required String pathParams,
  }) : super(pathParams: pathParams);
}

class RequestParamsWithGenre extends RequestParams {
  final String genreId;
  final int page;

  RequestParamsWithGenre({
    required this.genreId,
    this.page = 1,
  }) : super(pathParams: 'discover/movie');
}

class RequestParamsWithQuery extends RequestParams {
  final String query;
  final int page;

  RequestParamsWithQuery({
    required this.query,
    this.page = 1,
  }) : super(pathParams: 'search/movie');
}

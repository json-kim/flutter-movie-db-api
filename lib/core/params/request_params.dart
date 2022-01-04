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

  @override
  String toString() {
    return '$pathParams?api_key=$apiKey&language=$language';
  }
}

class RequestParamsWithPage extends RequestParams {
  final int page;

  RequestParamsWithPage({
    this.page = 1,
    required String pathParams,
  }) : super(pathParams: pathParams);

  @override
  String toString() {
    return super.toString() + '&page=$page';
  }
}

class RequestParamsWithGenre extends RequestParams {
  final int genreId;
  final int page;

  RequestParamsWithGenre({
    required this.genreId,
    this.page = 1,
  }) : super(pathParams: 'discover/movie');

  @override
  String toString() {
    return super.toString() + '&with_genres=$genreId&page=$page';
  }
}

class RequestParamsWithQuery extends RequestParams {
  final String query;
  final int page;
  String get queryParam =>
      (query.split(' ')..removeWhere((e) => e.trim().isEmpty)).join('+');

  RequestParamsWithQuery({
    required this.query,
    this.page = 1,
  }) : super(pathParams: 'search/movie');

  @override
  String toString() {
    return super.toString() + '&query=$queryParam&page=$page';
  }
}

String changeParamsToPath(RequestParams params) {
  return kBaseUrl + params.toString();
}

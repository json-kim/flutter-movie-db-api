import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/data/data_source/api/tmdb_api.dart';

void main() {
  group('TMDB API를 테스트 합니다.', () {
    TMDBApi tmdbApi = TMDBApi();

    test('영화 정보를 잘 가져오는지 테스트합니다.', () async {
      final testParams = RequestParamsWithPage(pathParams: 'movie/popular');
      final result = await tmdbApi.fetch(changeParamsToPath(testParams));

      result.when(
          success: (jsonString) {},
          error: (message) {
            throw Exception(message);
          });
    });

    test('쿼리를 가지고 영화 정보를 잘 가져오는지 테스트합니다.', () async {
      final testParams = RequestParamsWithQuery(query: '스파이더맨');

      final result = await tmdbApi.fetch(changeParamsToPath(testParams));

      result.when(
          success: (jsonString) {},
          error: (message) {
            throw Exception(message);
          });
    });

    test('장르에 맞는 영화 정보를 잘 가져오는지 테스트합니다.', () async {
      final testParams = RequestParamsWithGenre(genreId: 28);

      final result = await tmdbApi.fetch(changeParamsToPath(testParams));

      result.when(
          success: (jsonString) {},
          error: (message) {
            throw Exception(message);
          });
    });

    test('현재 상영중인 영화 정보를 잘 가져오는지 테스트합니다.', () async {
      final testParams = RequestParamsWithPage(pathParams: 'movie/now_playing');

      final result = await tmdbApi.fetch(changeParamsToPath(testParams));

      result.when(
          success: (jsonString) {},
          error: (message) {
            throw Exception(message);
          });
    });

    test('키워드를 가지고 영화 정보를 잘 가져오는지 테스트합니다.', () async {
      final keywordId = 9715;
      final testParams =
          RequestParamsWithPage(pathParams: 'keyword/$keywordId/movies');

      final result = await tmdbApi.fetch(changeParamsToPath(testParams));

      result.when(
          success: (jsonString) {},
          error: (message) {
            throw Exception(message);
          });
    });

    test('추천 영화 정보를 잘 가져오는지 테스트합니다.', () async {
      final movieId = 634649;
      final testParams =
          RequestParamsWithPage(pathParams: 'movie/$movieId/recommendations');

      final result = await tmdbApi.fetch(changeParamsToPath(testParams));

      result.when(
          success: (jsonString) {},
          error: (message) {
            throw Exception(message);
          });
    });

    test('비슷한 영화 정보를 잘 가져오는지 테스트합니다.', () async {
      final movieId = 634649;
      final testParams =
          RequestParamsWithPage(pathParams: 'movie/$movieId/similar');

      final result = await tmdbApi.fetch(changeParamsToPath(testParams));

      result.when(
          success: (jsonString) {},
          error: (message) {
            throw Exception(message);
          });
    });

    test('장르 리스트를 잘 가져오는지 테스트합니다.', () async {
      final testParams = RequestParams(pathParams: 'genre/movie/list');

      final result = await tmdbApi.fetch(changeParamsToPath(testParams));

      result.when(
          success: (jsonString) {},
          error: (message) {
            throw Exception(message);
          });
    });

    test('키워드 리스트를 잘 가져오는지 테스트합니다.', () async {
      final movieId = 634649;
      final testParams = RequestParams(pathParams: 'movie/$movieId/keywords');

      final result = await tmdbApi.fetch(changeParamsToPath(testParams));

      result.when(
          success: (jsonString) {},
          error: (message) {
            throw Exception(message);
          });
    });

    test('리뷰를 잘 가져오는지 테스트합니다.', () async {
      final movieId = 634649;
      final testParams = RequestParams(
          language: 'en-US', pathParams: 'movie/$movieId/reviews');

      final result = await tmdbApi.fetch(changeParamsToPath(testParams));

      result.when(
          success: (jsonString) {},
          error: (message) {
            throw Exception(message);
          });
    });

    test('비디오 정보를 잘 가져오는지 테스트합니다.', () async {
      final movieId = 634649;
      final testParams = RequestParams(pathParams: 'movie/$movieId/videos');

      final result = await tmdbApi.fetch(changeParamsToPath(testParams));

      result.when(
          success: (jsonString) {},
          error: (message) {
            throw Exception(message);
          });
    });

    test('크레딧 정보를 잘 가져오는지 테스트합니다.', () async {
      final movieId = 634649;
      final testParams = RequestParams(pathParams: 'movie/$movieId/credits');

      final result = await tmdbApi.fetch(changeParamsToPath(testParams));

      result.when(success: (jsonString) {
        print(jsonString);
      }, error: (message) {
        throw Exception(message);
      });
    });

    test('인물 정보를 잘 가져오는지 테스트합니다.', () async {
      final personId = 287;
      final testParams = RequestParams(pathParams: 'person/$personId');

      final result = await tmdbApi.fetch(changeParamsToPath(testParams));

      result.when(success: (jsonString) {
        print(jsonString);
      }, error: (message) {
        throw Exception(message);
      });
    });
  });
}

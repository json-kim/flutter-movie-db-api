import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/data/data_source/api/tmdb_api.dart';
import 'package:movie_search/data/repository/api_movie_data_repository.dart';

void main() {
  group('영화 api 레포지토리를 테스트합니다.', () {
    final repository = ApiMovieDataRepository(TMDBApi());

    test('인기 영화 정보를 파싱합니다.', () async {
      final result = await repository
          .fetch(RequestParamsWithPage(pathParams: 'movie/popular'));

      result.when(success: (movies) {
        expect(movies.length, 20);
      }, error: (message) {
        print(message);
      });
    });

    test('쿼리를 가지고 영화 정보를 가져와 파싱합니다.', () async {
      final result =
          await repository.fetch(RequestParamsWithQuery(query: '스파이더맨'));

      result.when(
          success: (movies) {
            expect(movies.first.id, 557);
          },
          error: (message) {});
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/data/data_source/api/tmdb_api.dart';
import 'package:movie_search/data/repository/api_keyword_data_repository.dart';

void main() {
  test('키워드 api 레포지토리를 테스트합니다.', () async {
    final ApiKeywordDataRepository repository =
        ApiKeywordDataRepository(TMDBApi());

    final movieId = 634649;
    final testParams = RequestParams(pathParams: 'movie/$movieId/keywords');
    final result = await repository.fetch(testParams);

    result.when(
        success: (keywords) {
          print(keywords);
        },
        error: (message) {});
  });
}

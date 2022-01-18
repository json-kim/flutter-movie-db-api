import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/data/data_source/api/tmdb_api.dart';
import 'package:movie_search/data/repository/api_credit_data_repository.dart';

void main() {
  test('크레딧 api 레포지토리를 테스트합니다.', () async {
    final ApiCreditDataRepository repository =
        ApiCreditDataRepository(TMDBApi());

    final movieId = 634649;
    final testParams = RequestParams(pathParams: 'movie/$movieId/credits');

    final result = await repository.fetch(testParams);
    result.when(
        success: (credits) {
          print(credits);
        },
        error: (message) {});
  });
}

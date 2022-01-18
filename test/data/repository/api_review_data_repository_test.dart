import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/data/data_source/api/tmdb_api.dart';
import 'package:movie_search/data/repository/api_review_data_repository.dart';

void main() {
  test('리뷰 api 레포지토리를 테스트합니다.', () async {
    final ApiReviewDataRepository repository =
        ApiReviewDataRepository(TMDBApi());

    final movieId = 634649;
    final testParams =
        RequestParams(language: 'en-US', pathParams: 'movie/$movieId/reviews');

    final result = await repository.fetch(testParams);

    result.when(
        success: (reviews) {
          print(reviews.take(5));
        },
        error: (message) {});
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/data/repository/movie_data/review_data_repository_impl.dart';

void main() {
  test('리뷰 api 레포지토리를 테스트합니다.', () async {
    final ReviewDataRepositoryImpl repository =
        ReviewDataRepositoryImpl(MovieRemoteDataSource());

    final movieId = 634649;
    final testParams = Param.reviewWithMovie(movieId);

    final result = await repository.fetch(testParams);

    result.when(
        success: (reviews) {
          print(reviews.take(5));
        },
        error: (message) {});
  });
}

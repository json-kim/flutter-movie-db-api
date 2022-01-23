import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/data/repository/movie_data/keyword_data_repository_impl.dart';

void main() {
  test('키워드 api 레포지토리를 테스트합니다.', () async {
    final KeywordDataRepositoryImpl repository =
        KeywordDataRepositoryImpl(MovieRemoteDataSource());

    final movieId = 634649;
    final testParams = Param.keywordWithMovie(movieId);
    final result = await repository.fetch(testParams);

    result.when(
        success: (keywords) {
          print(keywords);
        },
        error: (message) {});
  });
}

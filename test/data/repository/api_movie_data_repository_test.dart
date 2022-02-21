import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/data/repository/movie_data/movie_data_repository_impl.dart';

void main() {
  group('영화 api 레포지토리를 테스트합니다.', () {
    final repository = MovieDataRepositoryImpl(MovieRemoteDataSource());

    test('인기 영화 정보를 파싱합니다.', () async {
      final result = await repository.fetch(Param.moviePopular());

      result.when(success: (page) {
        expect(page.items.length, 20);
      }, error: (message) {
        print(message);
      });
    });

    test('쿼리를 가지고 영화 정보를 가져와 파싱합니다.', () async {
      final result = await repository.fetch(Param.movieWithQuery('스파이더맨'));

      result.when(
          success: (page) {
            expect(page.items.first.id, 557);
          },
          error: (message) {});
    });
  });
}

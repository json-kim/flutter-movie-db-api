import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/data/repository/movie_data/genre_data_repository_impl.dart';

void main() {
  test('장르 api 레포지토리를 테스트합니다.', () async {
    final GenreDataRepositoryImpl repository =
        GenreDataRepositoryImpl(MovieRemoteDataSource());

    final result = await repository.fetch(Param.genres());

    result.when(
        success: (genres) {
          expect(genres.length, 19);
        },
        error: (message) {});
  });
}

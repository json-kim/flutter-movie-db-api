import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/data/data_source/api/tmdb_api.dart';
import 'package:movie_search/data/repository/movie_data/genre_data_repository_impl.dart';

void main() {
  test('장르 api 레포지토리를 테스트합니다.', () async {
    final GenreDataRepositoryImpl repository =
        GenreDataRepositoryImpl(TMDBApi());

    final result =
        await repository.fetch(RequestParams(pathParams: 'genre/movie/list'));

    result.when(
        success: (genres) {
          expect(genres.length, 19);
        },
        error: (message) {});
  });
}

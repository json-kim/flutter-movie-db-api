import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/data/data_source/tmdb_api.dart';
import 'package:movie_search/data/repository/api_genre_data_repository.dart';

void main() {
  test('장르 api 레포지토리를 테스트합니다.', () async {
    final ApiGenreDataRepository repository = ApiGenreDataRepository(TMDBApi());

    final result =
        await repository.fetch(RequestParams(pathParams: 'genre/movie/list'));

    result.when(
        success: (genres) {
          expect(genres.length, 19);
        },
        error: (message) {});
  });
}

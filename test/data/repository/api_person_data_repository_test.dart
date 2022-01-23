import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/data/data_source/api/tmdb_api.dart';
import 'package:movie_search/data/repository/movie_data/person_data_repository_impl.dart';

void main() {
  test('인물 api 레포지토리를 테스트합니다.', () async {
    final PersonDataRepositoryImpl repository =
        PersonDataRepositoryImpl(TMDBApi());

    final personId = 287;
    final testParams = RequestParams(pathParams: 'person/$personId');

    final result = await repository.fetch(testParams);

    result.when(
        success: (person) {
          print(person);
        },
        error: (message) {});
  });
}

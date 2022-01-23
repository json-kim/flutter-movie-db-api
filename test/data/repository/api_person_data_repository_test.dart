import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/data/repository/movie_data/person_data_repository_impl.dart';

void main() {
  test('인물 api 레포지토리를 테스트합니다.', () async {
    final PersonDataRepositoryImpl repository =
        PersonDataRepositoryImpl(MovieRemoteDataSource());

    final personId = 287;
    final testParams = Param.personDetail(personId);

    final result = await repository.fetch(testParams);

    result.when(
        success: (person) {
          print(person);
        },
        error: (message) {});
  });
}

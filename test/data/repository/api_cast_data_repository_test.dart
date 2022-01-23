import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/data/data_source/api/tmdb_api.dart';
import 'package:movie_search/data/repository/movie_data/cast_data_repository_impl.dart';

void main() {
  test('캐스팅 정보를 가져와 모델로 잘 만들어지는지', () async {
    final CastDataRepositoryImpl repository = CastDataRepositoryImpl(TMDBApi());

    final fakeParams = RequestParams(pathParams: 'person/287/movie_credits');

    final result = await repository.fetch(fakeParams);

    result.when(
        success: (casts) {
          expect(casts.first.id, 297);
        },
        error: (message) {});
  });
}

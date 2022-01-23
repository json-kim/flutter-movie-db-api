import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/data/repository/movie_data/cast_data_repository_impl.dart';

void main() {
  test('캐스팅 정보를 가져와 모델로 잘 만들어지는지', () async {
    final CastDataRepositoryImpl repository =
        CastDataRepositoryImpl(MovieRemoteDataSource());

    final fakeParams = Param.castWithPerson(287);

    final result = await repository.fetch(fakeParams);

    result.when(
        success: (casts) {
          expect(casts.first.id, 297);
        },
        error: (message) {});
  });
}

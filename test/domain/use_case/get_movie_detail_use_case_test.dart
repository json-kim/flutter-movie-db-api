import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/data/data_source/tmdb_api.dart';
import 'package:movie_search/data/repository/api_movie_detail_data_repository.dart';
import 'package:movie_search/domain/usecase/get_movie_detail_use_case.dart';

void main() {
  test('영화 상세정보 가져오기 유스케이스 테스트', () async {
    final useCase =
        GetMovieDetailUseCase(ApiMovieDetailDataRepository(TMDBApi()));

    final result = await useCase(634649);

    result.when(
        success: (movieDetail) {
          print(movieDetail);
        },
        error: (message) {});
  });
}

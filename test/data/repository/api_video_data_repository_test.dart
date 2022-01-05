import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/data/data_source/tmdb_api.dart';
import 'package:movie_search/data/repository/api_video_data_repository.dart';

void main() {
  test('비디오 api 레포지토리를 테스트합니다.', () async {
    final ApiVideoDataRepository repository = ApiVideoDataRepository(TMDBApi());

    final movieId = 634649;
    final testParams = RequestParams(pathParams: 'movie/$movieId/videos');

    final result = await repository.fetch(testParams);

    result.when(
        success: (videos) {
          print(videos);
        },
        error: (message) {});
  });
}
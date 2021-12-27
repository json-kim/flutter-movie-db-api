import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/data/tmdb_api.dart';

void main() {
  test('영화정보 api 를 테스트합니다.', () async {
    TMDBApi _movieApi = TMDBApi();

    final response = await _movieApi.fetchMoviesWithPage();

    final totalPage = await _movieApi.fetchTotalPage();

    final genres = await _movieApi.fetchGenres();

    final searchResponse =
        await _movieApi.fetchMoviesWithQuery(query: '스파이더맨 노 웨이 홈');

    expect(response.first.title, '스파이더맨: 노 웨이 홈');

    expect(totalPage, 31706);

    expect(genres[0].name, '액션');

    expect(queryChange('스파이더맨 노 웨이 홈'), '스파이더맨+노+웨이+홈');

    expect(searchResponse.first.title, '스파이더맨: 노 웨이 홈');
  });
}

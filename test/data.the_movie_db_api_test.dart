import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/data/tmdb_api.dart';

void main() {
  test('영화정보 api 를 테스트합니다.', () async {
    TMDBApi _movieApi = TMDBApi();

    final response = await _movieApi.fetchMoviesWithPage();

    final totalPage = await _movieApi.fetchTotalPage();

    final searchMovies = await _movieApi.fetchMoviesWithQuery(query: '');

    final genres = await _movieApi.fetchGenres();

    // expect(response.first.title, '스파이더맨: 노 웨이 홈');

    // expect(totalPage, 31653);

    // expect(searchMovies.length, 20);

    expect(genres[0].name, '액션');
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/data/the_movie_db_api.dart';

void main() {
  test('영화정보 api 를 테스트합니다.', () async {
    TheMovieDBApi _movieApi = TheMovieDBApi();

    final response = await _movieApi.fetchMoviesWithPage(1);

    final totalPage = await _movieApi.fetchTotalPage();

    final searchMovies = await _movieApi.fetchMoviesWithQuery('');

    // expect(response.first.title, '스파이더맨: 노 웨이 홈');

    // expect(totalPage, 31653);

    expect(searchMovies.length, 20);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/data/tmdb_api.dart';
import 'package:movie_search/model/genre.dart';
import 'package:movie_search/ui/movie_search/movie_search_view_model.dart';

void main() {
  group('영화 검색 스크린 뷰모델 테스트입니다.', () {
    test('같은 장르 영화 가져오기 테스트입니다.', () async {
      MovieSearchViewModel model = MovieSearchViewModel(movieDBApi: TMDBApi());

      await model.getMoviesWithGenre(genre: Genre(id: 28, name: '액션'));
      await model.getMoviesWithGenre(genre: Genre(id: 28, name: '액션'));

      expect(model.movies.length, 40);
    });

    test('다른 장르 영화 가져오기 테스트입니다.', () async {
      MovieSearchViewModel model = MovieSearchViewModel(movieDBApi: TMDBApi());

      await model.getMoviesWithGenre(genre: Genre(id: 12, name: '모험'));

      expect(model.movies.length, 20);
    });
  });
}

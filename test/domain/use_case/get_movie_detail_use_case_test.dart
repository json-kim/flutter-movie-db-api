import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/data/data_source/api/tmdb_api.dart';
import 'package:movie_search/data/repository/api_movie_detail_data_repository.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_detail_use_case.dart';

void main() {
  test('영화 상세정보 가져오기 유스케이스 테스트', () async {
    final useCase =
        GetMovieDetailUseCase(ApiMovieDetailDataRepository(TMDBApi()));

    final result = await useCase(fakeMovie.id);

    result.when(
        success: (movieDetail) {
          print(movieDetail);
        },
        error: (message) {});
  });
}

final fakeMovie = Movie.fromJson(jsonDecode(fakeJson));

const fakeJson = '''
{
            "adult": false,
            "backdrop_path": "/1Rr5SrvHxMXHu5RjKpaMba8VTzi.jpg",
            "genre_ids": [
                28,
                12,
                878
            ],
            "id": 634649,
            "original_language": "en",
            "original_title": "Spider-Man: No Way Home",
            "overview": "정체가 탄로난 스파이더맨 피터 파커가 시간을 되돌리기 위해 닥터 스트레인지의 도움을 받던 중 뜻하지 않게 멀티버스가 열리게 되고, 이를 통해 자신의 숙적 닥터 옥토퍼스가 나타나며 사상 최악의 위기를 맞게 되는데...",
            "popularity": 7981.605,
            "poster_path": "/voddFVdjUoAtfoZZp2RUmuZILDI.jpg",
            "release_date": "2021-12-15",
            "title": "스파이더맨: 노 웨이 홈",
            "video": false,
            "vote_average": 8.4,
            "vote_count": 3722
        }
''';

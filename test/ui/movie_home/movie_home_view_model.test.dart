import 'package:flutter_test/flutter_test.dart';

void main() {
  group('무비 홈 뷰모델 테스트를 시작합니다.', () {
    test('현재 상영중인 영화정보를 요청합니다.', () async {
      // final viewModel = MovieHomeViewModel(tmdbApi: TMDBApi());
      //
      // await viewModel.loadNowPlayingMovies();
      //
      // expect(
      //   viewModel.nowPlayingMovies.first,
      //   Movie.fromJson(jsonDecode(fakeJson)),
      // );
    });
  });
}

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
            "popularity": 11671.933,
            "poster_path": "/voddFVdjUoAtfoZZp2RUmuZILDI.jpg",
            "release_date": "2021-12-15",
            "title": "스파이더맨: 노 웨이 홈",
            "video": false,
            "vote_average": 8.4,
            "vote_count": 2893
        }
''';

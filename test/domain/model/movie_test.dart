import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/model/movie_detail/movie_detail.dart';

void main() {
  test('MovieDetail 모델을 Movie 모델로 변환합니다.', () {
    final movieDetail = MovieDetail.fromJson(jsonDecode(fakeMovieDetailJson));

    final movie = Movie.fromMovieDetail(movieDetail);

    print(movie);
  });
}

const fakeMovieDetailJson = '''
{
    "adult": false,
    "backdrop_path": "/1Rr5SrvHxMXHu5RjKpaMba8VTzi.jpg",
    "belongs_to_collection": {
        "id": 531241,
        "name": "스파이더맨(MCU) 시리즈",
        "poster_path": "/nogV4th2P5QWYvQIMiWHj4CFLU9.jpg",
        "backdrop_path": "/AvnqpRwlEaYNVL6wzC4RN94EdSd.jpg"
    },
    "budget": 200000000,
    "genres": [
        {
            "id": 28,
            "name": "액션"
        },
        {
            "id": 12,
            "name": "모험"
        },
        {
            "id": 878,
            "name": "SF"
        }
    ],
    "homepage": "https://www.spidermannowayhome.movie",
    "id": 634649,
    "imdb_id": "tt10872600",
    "original_language": "en",
    "original_title": "Spider-Man: No Way Home",
    "overview": "정체가 탄로난 스파이더맨 피터 파커가 시간을 되돌리기 위해 닥터 스트레인지의 도움을 받던 중 뜻하지 않게 멀티버스가 열리게 되고, 이를 통해 자신의 숙적 닥터 옥토퍼스가 나타나며 사상 최악의 위기를 맞게 되는데...",
    "popularity": 6732.373,
    "poster_path": "/voddFVdjUoAtfoZZp2RUmuZILDI.jpg",
    "production_companies": [
        {
            "id": 420,
            "logo_path": "/hUzeosd33nzE5MCNsZxCGEKTXaQ.png",
            "name": "Marvel Studios",
            "origin_country": "US"
        },
        {
            "id": 84041,
            "logo_path": "/nw4kyc29QRpNtFbdsBHkRSFavvt.png",
            "name": "Pascal Pictures",
            "origin_country": "US"
        },
        {
            "id": 5,
            "logo_path": "/71BqEFAF4V3qjjMPCpLuyJFB9A.png",
            "name": "Columbia Pictures",
            "origin_country": "US"
        }
    ],
    "production_countries": [
        {
            "iso_3166_1": "US",
            "name": "United States of America"
        }
    ],
    "release_date": "2021-12-15",
    "revenue": 1691110988,
    "runtime": 148,
    "spoken_languages": [
        {
            "english_name": "English",
            "iso_639_1": "en",
            "name": "English"
        },
        {
            "english_name": "Tagalog",
            "iso_639_1": "tl",
            "name": ""
        }
    ],
    "status": "Released",
    "tagline": "무너진 세계, 차원을 뛰어넘는 위협!",
    "title": "스파이더맨: 노 웨이 홈",
    "video": false,
    "vote_average": 8.5,
    "vote_count": 5804
}
''';

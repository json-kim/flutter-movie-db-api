import 'dart:convert';

import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/data/data_source/tmdb_api.dart';
import 'package:movie_search/domain/entity/movie/movie.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

// TMDB API를 사용해서 영화 관련 데이터를 가져오는 클래스
class ApiMovieDataRepository
    implements MovieDataRepository<Movie, RequestParams> {
  final TMDBApi tmdbApi;

  ApiMovieDataRepository(this.tmdbApi);

  @override
  Future<Result<List<Movie>>> fetch(RequestParams params) async {
    String url = changeParamsToPath(params);
    final result = await tmdbApi.fetch(url);

    return result.when(success: (jsonBody) {
      List jsonResult = jsonDecode(jsonBody)['results'];
      List<Movie> movies = jsonResult.map((e) => Movie.fromJson(e)).toList();
      return Result.success(movies);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

// 유스케이스
// 쿼리를 가지고 영화 가져오기
// 인기 영화 가져오기
// 장르에 맞는 영화 가져오기
// 현재 상영중인 영화 가져오기
// 키워드를 가지고 영화 가져오기
// 추천 영화 가져오기
// 비슷한 영화 가져오기

// RequestParams 를 가지고 요청 url을 생성
// tmdbApi를 통해 응답받은 결과(문자열)를 가지고 파싱,
// 모델에 맞게 변환하는 작업

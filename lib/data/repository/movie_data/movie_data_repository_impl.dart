import 'dart:convert';

import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

class MovieDataRepositoryImpl
    implements MovieDataRepository<List<Movie>, Param> {
  final MovieRemoteDataSource _remoteDataSource;

  MovieDataRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Movie>>> fetch(Param param) async {
    final result = await _remoteDataSource.fetch(param);

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

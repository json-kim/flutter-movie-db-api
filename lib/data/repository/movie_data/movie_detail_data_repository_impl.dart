import 'dart:convert';

import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/domain/model/movie_detail/movie_detail.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

class MovieDetailDataRepositoryImpl
    implements MovieDataRepository<MovieDetail, Param> {
  final MovieRemoteDataSource _remoteDataSource;

  MovieDetailDataRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<MovieDetail>> fetch(Param param) async {
    final result = await _remoteDataSource.fetch(param);

    return result.when(success: (jsonBody) {
      final Map<String, dynamic> jsonResult = jsonDecode(jsonBody);
      final movieDetail = MovieDetail.fromJson(jsonResult);

      return Result.success(movieDetail);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

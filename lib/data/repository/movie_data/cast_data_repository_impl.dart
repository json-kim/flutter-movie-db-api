import 'dart:convert';

import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/domain/model/cast/cast.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

class CastDataRepositoryImpl implements MovieDataRepository<List<Cast>, Param> {
  final MovieRemoteDataSource _remoteDataSource;

  CastDataRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Cast>>> fetch(Param param) async {
    final result = await _remoteDataSource.fetch(param);

    return result.when(success: (jsonBody) {
      try {
        final List jsonCast = jsonDecode(jsonBody)['cast'];
        final List<Cast> casts = jsonCast.map((e) => Cast.fromJson(e)).toList();
        return Result.success(casts);
      } catch (e) {
        return Result.error('$runtimeType : 파싱 에러(${e.toString()})');
      }
    }, error: (message) {
      return Result.error(message);
    });
  }
}

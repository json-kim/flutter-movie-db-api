import 'dart:convert';

import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/domain/model/genre/genre.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

class GenreDataRepositoryImpl
    implements MovieDataRepository<List<Genre>, Param> {
  final MovieRemoteDataSource _remoteDataSource;

  GenreDataRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Genre>>> fetch(Param param) async {
    final result = await _remoteDataSource.fetch(param);

    return result.when(success: (jsonBody) {
      final List jsonGenres = jsonDecode(jsonBody)['genres'];
      final List<Genre> genres =
          jsonGenres.map((e) => Genre.fromJson(e)).toList();
      return Result.success(genres);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

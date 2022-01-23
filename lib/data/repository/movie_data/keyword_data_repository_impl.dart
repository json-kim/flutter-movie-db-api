import 'dart:convert';

import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/domain/model/keyword/keyword.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

class KeywordDataRepositoryImpl
    implements MovieDataRepository<List<Keyword>, Param> {
  final MovieRemoteDataSource _remoteDataSource;

  KeywordDataRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Keyword>>> fetch(Param param) async {
    final result = await _remoteDataSource.fetch(param);

    return result.when(success: (jsonBody) {
      final List jsonKeywords = jsonDecode(jsonBody)['keywords'];
      final List<Keyword> keywords =
          jsonKeywords.map((e) => Keyword.fromJson(e)).toList();
      return Result.success(keywords);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

import 'dart:convert';

import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/domain/model/credit/credit.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

class CreditDataRepositoryImpl
    implements MovieDataRepository<List<Credit>, Param> {
  final MovieRemoteDataSource _remoteDataSource;

  CreditDataRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Credit>>> fetch(Param param) async {
    final result = await _remoteDataSource.fetch(param);

    return result.when(success: (jsonBody) {
      final List jsonCast = jsonDecode(jsonBody)['cast'];
      final List<Credit> credits =
          jsonCast.map((e) => Credit.fromJson(e)).toList();
      return Result.success(credits);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

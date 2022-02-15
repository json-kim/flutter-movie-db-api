import 'dart:convert';

import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/domain/model/review/review.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

class ReviewDataRepositoryImpl
    implements MovieDataRepository<List<Review>, Param> {
  final MovieRemoteDataSource _remoteDataSource;

  ReviewDataRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Review>>> fetch(Param param) async {
    // final result = await _remoteDataSource.fetch(param);
    //
    // return result.when(success: (jsonBody) {
    //   final List jsonResult = jsonDecode(jsonBody)['results'];
    //   final List<Review> reviews =
    //       jsonResult.map((e) => Review.fromJson(e)).toList();
    //   return Result.success(reviews);
    // }, error: (message) {
    //   return Result.error(message);
    // });
    throw UnimplementedError();
  }
}

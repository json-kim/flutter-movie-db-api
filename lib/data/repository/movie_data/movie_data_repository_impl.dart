import 'dart:convert';

import 'package:movie_search/core/page/page.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

class MovieDataRepositoryImpl
    implements MovieDataRepository<Page<Movie>, Param> {
  final MovieRemoteDataSource _remoteDataSource;

  MovieDataRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<Page<Movie>>> fetch(Param param) async {
    final result = await _remoteDataSource.fetch(param);

    return result.when(success: (jsonBody) {
      final Map<String, dynamic> jsonData = jsonDecode(jsonBody);
      final int currentPage = jsonData['page'];
      final int lastPage = jsonData['total_pages'];
      List jsonResult = jsonData['results'];
      List<Movie> movies = jsonResult.map((e) => Movie.fromJson(e)).toList();

      final page = Page<Movie>(
        currentPage: currentPage,
        lastPage: lastPage,
        items: movies,
      );
      return Result.success(page);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

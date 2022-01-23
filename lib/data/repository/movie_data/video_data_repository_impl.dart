import 'dart:convert';

import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/domain/model/video/video.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';

class VideoDataRepositoryImpl
    implements MovieDataRepository<List<Video>, Param> {
  final MovieRemoteDataSource _remoteDataSource;

  VideoDataRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<List<Video>>> fetch(Param param) async {
    final result = await _remoteDataSource.fetch(param);

    return result.when(success: (jsonBody) {
      final List jsonResult = jsonDecode(jsonBody)['results'];
      final List<Video> videos =
          jsonResult.map((e) => Video.fromJson(e)).toList();

      var youtubeVideos =
          videos.where((element) => element.site == 'YouTube').toList();

      // 한국어 비디오가 없을 경우 영어로 된 비디오 불러오기
      if (youtubeVideos.isEmpty) {
        return _callWithLanguage(param, 'en-US');
      }
      return Result.success(videos);
    }, error: (message) {
      return Result.error(message);
    });
  }

  Future<Result<List<Video>>> _callWithLanguage(
      Param param, String language) async {
    final result = await _remoteDataSource.fetch(param, language: language);

    return result.when(success: (jsonBody) {
      final List jsonResult = jsonDecode(jsonBody)['results'];
      final List<Video> videos =
          jsonResult.map((e) => Video.fromJson(e)).toList();

      final youtubeVideos =
          videos.where((element) => element.site == 'YouTube').toList();

      return Result.success(youtubeVideos);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

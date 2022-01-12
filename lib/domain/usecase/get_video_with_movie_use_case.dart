import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/model/video/video.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetVideoWithMovieUseCase implements UseCase<List<Video>, Movie> {
  final MovieDataRepository<Video, RequestParams> _repository;

  GetVideoWithMovieUseCase(this._repository);

  @override
  Future<Result<List<Video>>> call(Movie movie) async {
    final params = RequestParams(pathParams: 'movie/${movie.id}/videos');

    final result = await _repository.fetch(params);

    return result.when(success: (videos) async {
      var youtubeVideos =
          videos.where((element) => element.site == 'YouTube').toList();

      // 한국어 비디오가 없을 경우 영어로 된 비디오 불러오기
      if (youtubeVideos.isEmpty) {
        return callWithLanguage(movie, 'en-US');
      }

      return Result.success(youtubeVideos);
    }, error: (message) {
      return Result.error(message);
    });
  }

  Future<Result<List<Video>>> callWithLanguage(
      Movie movie, String language) async {
    final params = RequestParams(
        pathParams: 'movie/${movie.id}/videos', language: language);
    final result = await _repository.fetch(params);

    return result.when(success: (videos) {
      final youtubeVideos =
          videos.where((element) => element.site == 'YouTube').toList();
      return Result.success(youtubeVideos);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

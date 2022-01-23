import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/video/video.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetVideoWithMovieUseCase implements UseCase<List<Video>, Param> {
  final MovieDataRepository<List<Video>, Param> _repository;

  GetVideoWithMovieUseCase(this._repository);

  @override
  Future<Result<List<Video>>> call(Param param) async {
    final result = await _repository.fetch(param);

    return result.when(success: (videos) async {
      return Result.success(videos);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

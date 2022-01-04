import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/entity/video/video.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetVideoWithMovieUseCase
    implements UseCase<Result<List<Video>>, RequestParams> {
  @override
  final MovieDataRepository repository;

  GetVideoWithMovieUseCase(this.repository);

  @override
  Future<Result<List<Video>>> call(RequestParams param) {
    // TODO: implement call
    throw UnimplementedError();
  }
}

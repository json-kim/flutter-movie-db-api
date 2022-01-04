import 'package:movie_search/core/params/request_params.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/entity/review/review.dart';
import 'package:movie_search/domain/repository/movie_data_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class GetReviewWithMovieUseCase
    implements UseCase<Result<List<Review>>, RequestParams> {
  @override
  final MovieDataRepository<Review, RequestParams> repository;

  GetReviewWithMovieUseCase(this.repository);

  @override
  Future<Result<List<Review>>> call(RequestParams param) async {
    final movieId = 634649;
    final params =
        RequestParams(language: 'en-US', pathParams: 'movie/$movieId/reviews');

    final result = await repository.fetch(params);

    return result.when(success: (reviews) {
      return Result.success(reviews);
    }, error: (message) {
      return Result.error(message);
    });
  }
}

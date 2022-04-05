import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/repository/bookmark_data_repository.dart';
import 'package:movie_search/domain/repository/review_data_repository.dart';

import 'use_case.dart';

class ResetUseCase implements UseCase<void, void> {
  final BookmarkDataRepository<Movie, int> _bookmarkMovieRepository;
  final BookmarkDataRepository<Person, int> _bookmarkPersonRepository;
  final ReviewDataRepository _reviewDataRepository;

  ResetUseCase(
    this._bookmarkMovieRepository,
    this._bookmarkPersonRepository,
    this._reviewDataRepository,
  );

  @override
  Future<Result<void>> call(void params) async {
    await _bookmarkMovieRepository.deleteAll();
    await _bookmarkPersonRepository.deleteAll();
    await _reviewDataRepository.deleteAll();

    return Result.success(null);
  }
}

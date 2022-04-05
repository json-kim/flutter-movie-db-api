import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/backup/backup_data.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/model/review/review.dart';
import 'package:movie_search/domain/repository/backup_repository.dart';
import 'package:movie_search/domain/repository/bookmark_data_repository.dart';
import 'package:movie_search/domain/repository/review_data_repository.dart';

import '../use_case.dart';

/// 로컬에 저장된 데이터 불러와서
/// 백업 데이터로 변환하여
/// 원격 서버에 저장
class SaveBackupUseCase extends UseCase<void, void> {
  final BackupRepository _repository;
  final BookmarkDataRepository<Movie, int> _bookmarkMovieRepository;
  final BookmarkDataRepository<Person, int> _bookmarkPersonRepository;
  final ReviewDataRepository _reviewDataRepository;

  SaveBackupUseCase(
    this._repository,
    this._bookmarkMovieRepository,
    this._bookmarkPersonRepository,
    this._reviewDataRepository,
  );

  @override
  Future<Result<void>> call(void param) async {
    final movies = await _getMovies();
    final persons = await _getPersons();
    final reviews = await _getReviews();

    final backupData = BackupData(
      uploadDate: DateTime.now(),
      movies: movies,
      persons: persons,
      reviews: reviews,
    );

    final result = await _repository.saveBackupData(backupData);

    return result.when(
      success: (saveResult) {
        return Result.success(saveResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  Future<List<Movie>> _getMovies() async {
    final result = await _bookmarkMovieRepository.loadAllDatas();

    return result.when(
      success: (list) {
        return list;
      },
      error: (message) {
        throw Exception(message);
      },
    );
  }

  Future<List<Person>> _getPersons() async {
    final result = await _bookmarkPersonRepository.loadAllDatas();

    return result.when(
      success: (list) {
        return list;
      },
      error: (message) {
        throw Exception(message);
      },
    );
  }

  Future<List<Review>> _getReviews() async {
    final result = await _reviewDataRepository.loadAllReviews();

    return result.when(
      success: (list) {
        return list;
      },
      error: (message) {
        throw Exception(message);
      },
    );
  }
}

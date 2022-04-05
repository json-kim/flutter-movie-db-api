import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/backup/backup_data.dart';
import 'package:movie_search/domain/model/backup/backup_item.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/repository/bookmark_data_repository.dart';
import 'package:movie_search/domain/repository/review_data_repository.dart';

import '../use_case.dart';
import 'load_backup_data_use_case.dart';

class RestoreBackupDataUseCase extends UseCase<void, BackupItem> {
  final BookmarkDataRepository<Movie, int> _bookmarkMovieRepository;
  final BookmarkDataRepository<Person, int> _bookmarkPersonRepository;
  final ReviewDataRepository _reviewDataRepository;
  final LoadBackupDataUseCase _loadBackupDataUseCase;

  RestoreBackupDataUseCase(
    this._bookmarkMovieRepository,
    this._bookmarkPersonRepository,
    this._reviewDataRepository,
    this._loadBackupDataUseCase,
  );

  @override
  Future<Result<void>> call(BackupItem backupItem) async {
    final backupData = await getBackupData(backupItem);

    final backupMovies = backupData.movies;
    final backupPersons = backupData.persons;
    final backupReviews = backupData.reviews;

    await _reviewDataRepository.restoreReviews(backupReviews);
    await _bookmarkMovieRepository.restoreDatas(backupMovies);
    await _bookmarkPersonRepository.restoreDatas(backupPersons);

    return Result.success(null);
  }

  Future<BackupData> getBackupData(BackupItem backupItem) async {
    final result = await _loadBackupDataUseCase(backupItem);

    return result.when(
      success: (backupData) {
        return backupData;
      },
      error: (message) {
        throw Exception(message);
      },
    );
  }
}

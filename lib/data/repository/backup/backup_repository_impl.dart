import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/remote/firebase/backup_remote_data_source.dart';
import 'package:movie_search/domain/model/backup/backup_data.dart';
import 'package:movie_search/domain/model/backup/backup_item.dart';
import 'package:movie_search/domain/repository/backup_repository.dart';

class BackupRepositoryImpl implements BackupRepository {
  final BackupRemoteDataSource _dataSource;

  BackupRepositoryImpl(this._dataSource);

  @override
  Future<Result<int>> deleteBackup(BackupItem item) async {
    final result = await _dataSource.deleteBackup(item);

    return result.when(
      success: (delResult) {
        return Result.success(delResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<BackupData>> getBackupData(String path) async {
    final result = await _dataSource.getBackupData(path);

    return result.when(
      success: (backupData) {
        return Result.success(backupData);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<List<BackupItem>>> getBackupItemList() async {
    final result = await _dataSource.getBackupList();

    return result.when(
      success: (backupList) {
        return Result.success(backupList);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<int>> saveBackupData(BackupData backupData) async {
    final result = await _dataSource.saveBackup(backupData);

    return result.when(
      success: (saveResult) {
        return Result.success(saveResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}

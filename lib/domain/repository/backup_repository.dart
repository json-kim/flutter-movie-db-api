import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/backup/backup_data.dart';
import 'package:movie_search/domain/model/backup/backup_item.dart';

abstract class BackupRepository {
  Future<Result<List<BackupItem>>> getBackupItemList();

  Future<Result<BackupData>> getBackupData(String path);

  Future<Result<int>> saveBackupData(BackupData backupData);

  Future<Result<int>> deleteBackup(BackupItem item);
}

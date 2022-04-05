import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/backup/backup_data.dart';
import 'package:movie_search/domain/model/backup/backup_item.dart';
import 'package:movie_search/domain/repository/backup_repository.dart';

import '../use_case.dart';

class LoadBackupDataUseCase extends UseCase<BackupData, BackupItem> {
  final BackupRepository _repository;

  LoadBackupDataUseCase(this._repository);

  @override
  Future<Result<BackupData>> call(BackupItem backupItem) async {
    final path = backupItem.path;

    final result = await _repository.getBackupData(path);

    return result.when(
      success: (backupData) {
        return Result.success(backupData);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}

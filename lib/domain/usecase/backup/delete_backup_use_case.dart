import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/backup/backup_item.dart';
import 'package:movie_search/domain/repository/backup_repository.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class DeleteBackupUseCase implements UseCase<void, BackupItem> {
  final BackupRepository _repository;

  DeleteBackupUseCase(this._repository);

  @override
  Future<Result<void>> call(BackupItem item) async {
    final result = await _repository.deleteBackup(item);

    return result.when(
      success: (delResult) {
        return Result.success(delResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}

import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/model/backup/backup_item.dart';
import 'package:movie_search/domain/repository/backup_repository.dart';

import '../use_case.dart';

class LoadBackupListUseCase extends UseCase<List<BackupItem>, void> {
  final BackupRepository _repository;

  LoadBackupListUseCase(this._repository);

  @override
  Future<Result<List<BackupItem>>> call(void param) async {
    final result = await _repository.getBackupItemList();

    return result.when(
      success: (list) {
        // 날짜 순으로 내림차순 정렬
        list.sort((a, b) => -a.uploadDate.compareTo(b.uploadDate));
        return Result.success(list);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}

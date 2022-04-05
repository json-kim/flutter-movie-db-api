import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/model/backup/backup_item.dart';

part 'setting_ui_event.freezed.dart';

@freezed
class SettingUiEvent with _$SettingUiEvent {
  const factory SettingUiEvent.snackBar(String message) = SnackBar;
  const factory SettingUiEvent.showBackupList(List<BackupItem> backupList) =
      ShowBackupList;
}

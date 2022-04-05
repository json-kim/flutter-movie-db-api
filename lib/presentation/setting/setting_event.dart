import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/domain/model/backup/backup_item.dart';

part 'setting_event.freezed.dart';

@freezed
class SettingEvent with _$SettingEvent {
  const factory SettingEvent.backup() = Backup;
  const factory SettingEvent.reset() = Reset;
  const factory SettingEvent.loadBackupList() = LoadBackupList;
  const factory SettingEvent.restoreBackupData(BackupItem item) =
      RestoreBackupData;
  const factory SettingEvent.deleteBackupData(BackupItem item) =
      DeleteBackupData;
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_search/domain/model/backup/backup_item.dart';
import 'package:movie_search/domain/usecase/backup/delete_backup_use_case.dart';
import 'package:movie_search/domain/usecase/backup/load_backup_list_use_case.dart';
import 'package:movie_search/domain/usecase/backup/restore_backup_data_use_case.dart';
import 'package:movie_search/domain/usecase/backup/save_backup_use_case.dart';
import 'package:movie_search/domain/usecase/reset_use_case.dart';

import 'setting_event.dart';
import 'setting_ui_event.dart';

class SettingViewModel with ChangeNotifier {
  final SaveBackupUseCase _saveBackupUseCase;
  final LoadBackupListUseCase _loadBackupListUseCase;
  final RestoreBackupDataUseCase _restoreBackupDataUseCase;
  final DeleteBackupUseCase _deleteBackupUseCase;
  final ResetUseCase _resetUseCase;

  final _streamController = StreamController<SettingUiEvent>.broadcast();
  Stream<SettingUiEvent> get uiEventStream => _streamController.stream;

  bool isLoading = false;

  SettingViewModel(
    this._saveBackupUseCase,
    this._loadBackupListUseCase,
    this._restoreBackupDataUseCase,
    this._deleteBackupUseCase,
    this._resetUseCase,
  );

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void onEvent(SettingEvent event) {
    event.when(
      backup: _backup,
      reset: _reset,
      loadBackupList: _loadBackupList,
      restoreBackupData: _restoreBackupData,
      deleteBackupData: _deleteBackupData,
    );
  }

  /// 백업 이벤트 콜백 함수
  Future<void> _backup() async {
    isLoading = true;
    notifyListeners();

    final result = await _saveBackupUseCase(null);

    result.when(
      success: (_) {
        _streamController.add(const SettingUiEvent.snackBar('백업 저장에 성공했습니다.'));
      },
      error: (message) {
        _streamController
            .add(const SettingUiEvent.snackBar('백업 데이터 저장에 실패했습니다.'));
      },
    );

    isLoading = false;
    notifyListeners();
  }

  /// 리셋 이벤트 콜백 함수
  Future<void> _reset() async {
    isLoading = true;
    notifyListeners();

    final result = await _resetUseCase(null);

    result.when(success: (_) {
      _streamController.add(const SettingUiEvent.snackBar('초기화에 성공했습니다.'));
    }, error: (message) {
      _streamController.add(const SettingUiEvent.snackBar('초기화에 실패했습니다.'));
    });

    isLoading = false;
    notifyListeners();
  }

  /// 백업리스트 로드 이벤트 콜백 함수
  Future<void> _loadBackupList() async {
    isLoading = true;
    notifyListeners();

    final result = await _loadBackupListUseCase(null);

    result.when(
      success: (list) {
        _streamController.add(SettingUiEvent.showBackupList(list));
      },
      error: (message) {},
    );

    isLoading = false;
    notifyListeners();
  }

  /// 백업데이터 초기화 이벤트 콜백 함수
  Future<void> _restoreBackupData(BackupItem backupItem) async {
    isLoading = true;
    notifyListeners();

    final result = await _restoreBackupDataUseCase(backupItem);

    result.when(
      success: (_) {
        // 백업 적용 후 다시 로드
        // _load();

        _streamController
            .add(const SettingUiEvent.snackBar('백업 데이터 적용 성공했습니다.'));
      },
      error: (message) {
        _streamController
            .add(const SettingUiEvent.snackBar('백업 실패. 다시 시도해 보세요.'));
      },
    );

    isLoading = false;
    notifyListeners();
  }

  /// 백업데이터 삭제 이벤트 콜백 함수
  Future<void> _deleteBackupData(BackupItem backupItem) async {
    isLoading = true;
    notifyListeners();

    final result = await _deleteBackupUseCase(backupItem);

    result.when(
      success: (_) {
        _streamController.add(const SettingUiEvent.snackBar('삭제 되었습니다.'));
      },
      error: (message) {
        _streamController
            .add(const SettingUiEvent.snackBar('백업 데이터 삭제 실패. 다시 시도해보세요'));
      },
    );

    isLoading = false;
    notifyListeners();
  }
}

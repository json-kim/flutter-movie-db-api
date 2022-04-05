import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_search/domain/model/backup/backup_item.dart';
import 'package:movie_search/presentation/auth/auth_event.dart';
import 'package:movie_search/presentation/auth/auth_view_model.dart';
import 'package:movie_search/presentation/global_components/check_dialog.dart';
import 'package:movie_search/presentation/setting/setting_event.dart';
import 'package:movie_search/presentation/setting/setting_view_model.dart';
import 'package:provider/provider.dart';

import 'components/backup_dialog.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  StreamSubscription? _subscription;

  @override
  void initState() {
    Future.microtask(() async {
      final viewModel = context.read<SettingViewModel>();

      viewModel.uiEventStream.listen((event) {
        event.when(
          snackBar: (message) {
            final snackBar = SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(message),
            );

            _scaffoldMessengerKey.currentState
              ?..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          },
          showBackupList: (backupList) {
            final dialog = BackupDialog(
              backupList: backupList,
              onTap: (BackupItem item) async {
                final result = await showDialog(
                  context: context,
                  builder: (context) =>
                      const CheckDialog(content: '정말로 복원하시겠습니까?'),
                );

                if (result ?? false) {
                  viewModel.onEvent(SettingEvent.restoreBackupData(item));
                  Navigator.pop(context);
                }
              },
              onDeleteTap: (BackupItem item) async {
                final result = await showDialog(
                  context: context,
                  builder: (context) =>
                      const CheckDialog(content: '정말로 삭제하시겠습니까?'),
                );

                if (result ?? false) {
                  viewModel.onEvent(SettingEvent.deleteBackupData(item));
                  Navigator.pop(context);
                }
              },
            );

            showDialog(
              context: context,
              builder: (context) => dialog,
            );
          },
        );
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settingViewModel = context.watch<SettingViewModel>();

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('프로필 및 기타 설정'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Consumer<AuthViewModel>(
                    builder: (context, viewModel, _) => Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: viewModel.user.photoUrl == ''
                                ? Image.asset(
                                    'asset/image/avatar_placeholder.png')
                                : CachedNetworkImage(
                                    imageUrl: viewModel.user.photoUrl,
                                    errorWidget: (context, _, __) => Image.asset(
                                        'asset/image/avatar_placeholder.png'),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Text(
                            '${viewModel.user.userName}님 안녕하세요',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () {
                    settingViewModel.onEvent(SettingEvent.backup());
                  },
                  child: SizedBox(
                    height: 48,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [Text('서버에 백업하기')],
                      ),
                    ),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () {
                    settingViewModel.onEvent(SettingEvent.loadBackupList());
                  },
                  child: SizedBox(
                    height: 48,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [Text('백업 불러오기')],
                      ),
                    ),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () async {
                    final dialog = AlertDialog(
                      content: Text('정말로 리셋하시겠어요?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop<bool>(false);
                            },
                            child: Text('취소')),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop<bool>(true);
                            },
                            child: Text('리셋')),
                      ],
                    );

                    final resetCheck = await showDialog(
                        context: context, builder: (context) => dialog);

                    if (resetCheck == true) {
                      settingViewModel.onEvent(SettingEvent.reset());
                    }
                  },
                  child: SizedBox(
                    height: 48,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [Text('리셋하기')],
                      ),
                    ),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () async {
                    final dialog = AlertDialog(
                      content: Text('로그아웃하시겠어요?'),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop<bool>(false);
                            },
                            child: Text('취소')),
                        TextButton(
                            onPressed: () {
                              Navigator.of(context).pop<bool>(true);
                            },
                            child: Text('로그아웃')),
                      ],
                    );

                    final logoutCheck = await showDialog(
                        context: context, builder: (context) => dialog);

                    if (logoutCheck == true) {
                      context.read<AuthViewModel>().onEvent(AuthEvent.logout());
                    }
                  },
                  child: SizedBox(
                    height: 48,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [Text('로그아웃')],
                      ),
                    ),
                  ),
                ),
                const Divider(),
                InkWell(
                  onTap: () async {},
                  child: SizedBox(
                    height: 48,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [Text('앱 정보')],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (settingViewModel.isLoading)
              Container(
                color: Colors.transparent,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}

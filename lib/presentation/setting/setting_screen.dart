import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:movie_search/data/data_source/local/token_local_data_source.dart';
import 'package:movie_search/domain/usecase/auth/constants.dart';
import 'package:movie_search/presentation/auth/auth_event.dart';
import 'package:movie_search/presentation/auth/auth_view_model.dart';
import 'package:provider/provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('프로필 및 기타 설정'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Consumer<AuthViewModel>(
              builder: (context, viewModel, _) => Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: viewModel.user.photoUrl == ''
                          ? Image.asset('asset/image/avatar_placeholder.png')
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
            onTap: () {},
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
            onTap: () {},
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
            onTap: () {},
            child: SizedBox(
              height: 60,
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
    );
  }
}

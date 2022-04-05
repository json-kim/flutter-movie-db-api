import 'package:movie_search/service/package_info_service.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final packageInfo = PackageInfoService.instance.packageInfo;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('앱 정보'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(
              flex: 1,
            ),
            Image.asset(
              'asset/icon/vector_icon.png',
              width: 40.w,
            ),
            const SizedBox(height: 32),
            Text('현재 버전 ${packageInfo.version}'),
            const Spacer(
              flex: 1,
            ),
            const Divider(height: 0),
            InkWell(
              onTap: () {
                showAboutDialog(
                    applicationIcon: Image.asset(
                      'asset/icon/vector_icon.png',
                      width: 12.w,
                    ),
                    applicationName: '영화 리뷰',
                    applicationVersion: packageInfo.version,
                    context: context);
              },
              child: Container(
                height: 8.h,
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text('오픈소스 라이선스'),
              ),
            ),
            const Divider(height: 0),
            InkWell(
              onTap: () {
                // launch(privacyPolicyUrl);
              },
              child: Container(
                height: 8.h,
                width: double.infinity,
                alignment: Alignment.center,
                child: const Text('개인정보 처리방침'),
              ),
            ),
            const Divider(height: 0),
            const Spacer(
              flex: 6,
            ),
            const Text('jsonKim.dev Limited.'),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

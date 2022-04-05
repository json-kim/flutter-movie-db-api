import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoService {
  PackageInfo? _packageInfo;
  PackageInfo get packageInfo =>
      _packageInfo ??
      PackageInfo(
        appName: 'Unknown',
        packageName: 'Unknown',
        version: 'Unknown',
        buildNumber: 'Unknown',
        buildSignature: 'Unknown',
      );

  PackageInfoService._();

  static PackageInfoService _instance = PackageInfoService._();
  static PackageInfoService get instance => _instance;

  Future<void> init() async {
    final info = await PackageInfo.fromPlatform();
    _packageInfo = info;
  }
}

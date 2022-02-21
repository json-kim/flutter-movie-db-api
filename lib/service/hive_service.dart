import 'package:hive_flutter/hive_flutter.dart';

Future<void> hiveSetting() async {
  await Hive.initFlutter();
  Hive.openBox<int>('search_history');
}

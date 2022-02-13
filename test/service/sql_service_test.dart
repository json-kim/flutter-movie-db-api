import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/service/sql_service.dart';

void main() {
  group('db 를 테스트 합니다.', () {
    test('sql 서비스를 테스트합니다.', () async {
      await SqlService.instance.init();
      final db = SqlService.instance.db;

      print(db?.isOpen.toString());

      // 테스트 불가
    });

    test('메모리 sql 테스트 합니다.', () {});
  });
}

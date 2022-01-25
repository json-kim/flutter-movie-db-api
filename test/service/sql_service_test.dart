import 'package:flutter_test/flutter_test.dart';
import 'package:movie_search/service/sql_service.dart';

void main() {
  test('sql 서비스를 테스트합니다.', () async {
    await SqlService.instance.init();
    final db = SqlService.instance.db;

    print(db?.isOpen.toString());

    // 테스트 불가
  });
}

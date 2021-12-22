import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('타이머를 테스트합니다.', () async {
    Timer timer = Timer(const Duration(milliseconds: 300), () {});

    expect(timer.isActive, true);

    Future.delayed(Duration(milliseconds: 500)).then((_) {
      expect(timer.isActive, false);
    });
  });
}

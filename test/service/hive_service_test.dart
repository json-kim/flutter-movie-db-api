import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:movie_search/data/data_source/local/entity/search_history_db_entity.dart';
import 'package:movie_search/domain/model/search_history/search_history.dart';

void main() {
  test('hive 테스트합니다.', () async {
    final fakeHistory = SearchHistory(
        id: 'testId', content: 'testContent', searchTime: DateTime.now());

    final entity = SearchHistoryDbEntity.fromModel(fakeHistory);

    Hive.init('test/service/test_box');
    await Hive.deleteFromDisk();
    Hive.registerAdapter(SearchHistoryDbEntityAdapter());

    final box = await Hive.openBox<SearchHistoryDbEntity>('search_history');

    await box.put('testId', entity);

    final entityResult = box.get('testId');

    final modelResult = entityResult?.toSearchHistory();

    expect(modelResult?.id, 'testId');
  });
  test('hive 삭제 테스트합니다.', () async {
    final fakeHistory = SearchHistory(
        id: 'testId', content: 'testContent', searchTime: DateTime.now());

    final entity = SearchHistoryDbEntity.fromModel(fakeHistory);

    Hive.init('test/service/test_box');
    await Hive.deleteFromDisk();
    Hive.registerAdapter(SearchHistoryDbEntityAdapter());

    final box = await Hive.openBox<SearchHistoryDbEntity>('search_history');
    await box.deleteAll(box.keys); // 전체 삭제
    await box.put('testId', entity);

    final entityResult = box.get('testId');

    final modelResult = entityResult?.toSearchHistory();

    expect(modelResult?.id, 'testId');
  });
  test('hive 업데이트 테스트합니다.', () async {
    final fakeHistory1 = SearchHistory(
        id: 'testId', content: 'testContent', searchTime: DateTime.now());
    final fakeHistory2 = SearchHistory(
        id: 'testId', content: 'testContent2', searchTime: DateTime.now());

    final entity1 = SearchHistoryDbEntity.fromModel(fakeHistory1);
    final entity2 = SearchHistoryDbEntity.fromModel(fakeHistory2);

    Hive.init('test/service/test_box');
    Hive.registerAdapter(SearchHistoryDbEntityAdapter());

    final box = await Hive.openBox<SearchHistoryDbEntity>('search_history');
    await box.put('testId', entity1);
    await box.put('testId', entity2);

    final entityResult = box.get('testId');

    final modelResult = entityResult?.toSearchHistory();

    expect(modelResult?.content, 'testContent2');
    await Hive.deleteFromDisk();
  });
}

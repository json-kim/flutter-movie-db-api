import 'package:movie_search/core/resources/result.dart';

abstract class ViewModel {
  void init() {}

  void dispose() {}

  Future<void> loadData() async {}

  Future<void> saveData() async {}

  Future<void> updateData() async {}

  Future<void> deleteData() async {}
}

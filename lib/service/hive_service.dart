import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_search/data/data_source/local/entity/search_history_db_entity.dart';

class HiveService {
  Box<SearchHistoryDbEntity>? _searchBox;
  Box<SearchHistoryDbEntity>? get searchBox => _searchBox;

  HiveService._();

  static final HiveService _instance = HiveService._();
  static HiveService get instance => _instance;

  Future<void> init() async {
    await Hive.initFlutter();
    await Hive.deleteFromDisk();
    Hive.registerAdapter(SearchHistoryDbEntityAdapter());

    _searchBox = await Hive.openBox<SearchHistoryDbEntity>('search_history');
  }
}
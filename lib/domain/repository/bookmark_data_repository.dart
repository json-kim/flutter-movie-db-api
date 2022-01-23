import 'package:movie_search/core/result/result.dart';

abstract class BookmarkDataRepository<DataType, ParamType> {
  Future<Result<List<DataType>>> loadDatas(int page);

  Future<Result<DataType>> loadData(ParamType param);

  Future<Result<int>> deleteData(ParamType param);

  Future<Result<int>> saveData(DataType param);
}

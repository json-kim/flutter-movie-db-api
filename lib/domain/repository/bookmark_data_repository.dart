import 'package:movie_search/core/result/result.dart';

abstract class BookmarkDataRepository<DataType, ParamType> {
  Future<Result<List<DataType>>> loadAllDatas();

  Future<Result<List<DataType>>> loadDataList(int page);

  Future<Result<DataType>> loadData(ParamType param);

  Future<Result<int>> deleteData(ParamType param);

  Future<Result<void>> deleteAll();

  Future<Result<int>> saveData(DataType data);

  Future<Result<void>> restoreDatas(List<DataType> datas);
}

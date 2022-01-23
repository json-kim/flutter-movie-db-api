import 'package:movie_search/core/result/result.dart';

abstract class MovieDataRepository<DataType, ParamType> {
  Future<Result<DataType>> fetch(ParamType param);
}

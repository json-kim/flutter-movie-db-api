import 'package:freezed_annotation/freezed_annotation.dart';

part 'data_list_state.freezed.dart';

@freezed
class DataListState<T> with _$DataListState<T> {
  const factory DataListState(
    List<T> data,
    bool isLoading,
  ) = _DataListState;
}

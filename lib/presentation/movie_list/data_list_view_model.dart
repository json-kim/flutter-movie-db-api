import 'package:flutter/material.dart';
import 'package:movie_search/core/resources/result.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

import 'data_list_state.dart';

/// List<T>형식의 데이터를 가져오는 유스케이스 1개만을 사용하는 뷰모델
class DataListViewModel<T, P> with ChangeNotifier {
  final UseCase<List<T>, P> _useCase;
  final P data;
  DataListState<T> state = DataListState([], false);

  DataListViewModel(this._useCase, this.data) {
    loadData();
  }

  Future<void> loadData() async {
    final Result<List<T>> result = await _useCase(data);

    result.when(
        success: (List<T> data) {
          state = state.copyWith(data: data);
        },
        error: (message) {});

    notifyListeners();
  }
}

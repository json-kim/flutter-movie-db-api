import 'package:flutter/material.dart';
import 'package:movie_search/core/page/page.dart' as page;
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

import 'data_list_state.dart';

/// [UseCase] 1개만을 사용하는 뷰모델
/// [UseCase]는 P타입의 데이터를 가지고 List<T>타입의 데이터 리스트를 가져온다.
class DataListViewModel<T, P extends Param> with ChangeNotifier {
  final UseCase<List<T>, Param> _useCase;
  final P _param;
  DataListState<T> _state = DataListState([], false);
  DataListState<T> get state => _state;

  DataListViewModel(this._useCase, this._param) {
    _loadData();
  }

  Future<void> _loadData() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final Result<List<T>> result = await _useCase(_param);

    result.when(
        success: (List<T> data) {
          _state = _state.copyWith(data: data);
        },
        error: (message) {});

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }
}

class DataPageViewModel<T, P extends Param> with ChangeNotifier {
  final UseCase<page.Page<T>, Param> _useCase;
  final P _param;
  DataListState<T> _state = DataListState([], false);
  DataListState<T> get state => _state;

  DataPageViewModel(this._useCase, this._param) {
    _loadData();
  }

  Future<void> _loadData() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final Result<page.Page<T>> result = await _useCase(_param);

    result.when(
        success: (page.Page<T> page) {
          _state = _state.copyWith(data: page.items);
        },
        error: (message) {});

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }
}

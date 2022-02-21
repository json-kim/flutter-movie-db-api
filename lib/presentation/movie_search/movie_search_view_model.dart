import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/model/search_history/search_history.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_with_query_use_case.dart';
import 'package:movie_search/domain/usecase/search_history/search_history_use_cases.dart';
import 'package:movie_search/presentation/movie_search/movie_search_state.dart';

import 'movie_search_event.dart';

class MovieSearchViewModel with ChangeNotifier {
  final GetMovieWithQueryUseCase _getMovieWithQueryUseCase;
  final SearchHistoryUseCases _searchHistoryUseCases;
  String _currentQuery = '';

  MovieSearchState _state = MovieSearchState();

  MovieSearchState get state => _state;

  final _pagingController = PagingController<int, Movie>(firstPageKey: 1);

  PagingController<int, Movie> get pagingController => _pagingController;

  MovieSearchViewModel(
      this._getMovieWithQueryUseCase, this._searchHistoryUseCases) {
    _pagingController
        .addPageRequestListener((pageKey) => _searchMovies(pageKey));
    _loadSearchHistories();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  void onEvent(MovieSearchEvent event) {
    event.when(
      search: (page, query) => _searchMovies(page, query: query),
      saveHistory: _saveSearchHistory,
      loadHistory: _loadSearchHistories,
      deleteHistory: _deleteSearchHistory,
      deleteAllHistory: _deleteAllHistory,
    );
  }

  Future<void> _searchMovies(int page, {String? query}) async {
    if (query != null) {
      _currentQuery = query;
      _pagingController.itemList = [];
    }

    if (_currentQuery.isEmpty) {
      _pagingController.itemList = [];
    } else {
      final result = await _getMovieWithQueryUseCase(
          Param.movieWithQuery(_currentQuery, page: page));

      result.when(success: (pageResult) {
        final isLastPage = pageResult.isLastPage;
        final newItems = pageResult.items;

        if (isLastPage) {
          _pagingController.appendLastPage(newItems);
        } else {
          _pagingController.appendPage(newItems, page + 1);
        }
      }, error: (message) {
        //TODO: 에러 처리
        debugPrint(message);
        _pagingController.error = '검색 실패';
      });
    }
  }

  Future<void> _loadSearchHistories() async {
    _state = _state.copyWith(isLoading: true);
    notifyListeners();

    final result = await _searchHistoryUseCases.getSearchHistoriesUseCase(null);
    result.when(success: (historyList) {
      _state = _state.copyWith(histories: historyList);
    }, error: (message) {
      // TODO: 불러오기 실패 에러 처리
      debugPrint(message);
    });

    _state = _state.copyWith(isLoading: false);
    notifyListeners();
  }

  Future<void> _saveSearchHistory(String query) async {
    if (query.isEmpty) {
      return;
    }

    final SearchHistory history = SearchHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: query,
        searchTime: DateTime.now());

    final result =
        await _searchHistoryUseCases.saveSearchHistoryUseCase(history);

    result.when(success: (saveResult) async {
      if (saveResult == 1) {
        await _loadSearchHistories();
      }
    }, error: (message) {
      // TODO: 저장 실패 에러 처리
      debugPrint(message);
    });
  }

  Future<void> _deleteSearchHistory(SearchHistory history) async {
    final result =
        await _searchHistoryUseCases.deleteSearchHistoryUseCase(history.id);

    result.when(success: (deleteResult) async {
      if (deleteResult == 1) {
        await _loadSearchHistories();
      }
    }, error: (message) {
      // TODO: 삭제 실패 에러 처리
      debugPrint(message);
    });
  }

  Future<void> _deleteAllHistory() async {
    final result = await _searchHistoryUseCases.deleteAllHistoryUseCase(null);

    result.when(
      success: (deleteResult) async {
        if (deleteResult == 1) {
          await _loadSearchHistories();
        }
      },
      error: (message) {
        // TODO: 삭제 실패 에러 처리
        debugPrint(message);
      },
    );
  }
}

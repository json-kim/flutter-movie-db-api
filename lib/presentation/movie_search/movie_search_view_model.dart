import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_with_query_use_case.dart';
import 'package:movie_search/presentation/movie_search/movie_search_state.dart';

import 'movie_search_event.dart';

class MovieSearchViewModel with ChangeNotifier {
  final GetMovieWithQueryUseCase _getMovieWithQueryUseCase;
  String _currentQuery = '';

  MovieSearchState _state = MovieSearchState();

  MovieSearchState get state => _state;

  final _pagingController = PagingController<int, Movie>(firstPageKey: 1);

  PagingController<int, Movie> get pagingController => _pagingController;

  MovieSearchViewModel(this._getMovieWithQueryUseCase) {
    _pagingController
        .addPageRequestListener((pageKey) => _searchMovies(pageKey));
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  void onEvent(MovieSearchEvent event) {
    event.when(
      search: (page, query) => _searchMovies(page, query: query),
    );
  }

  Future<void> _searchMovies(int page, {String? query}) async {
    if (query != null) {
      _currentQuery = query;
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
}

import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_search/core/page/page.dart' as page;
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/domain/model/genre/genre.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_with_genre_use_case.dart';
import 'package:movie_search/domain/usecase/use_case.dart';

class MovieGenreViewModel with ChangeNotifier {
  final GetMovieWithGenreUseCase _getMovieWithGenreUseCase;
  final Genre _genre;
  Genre get genre => _genre;

  // MovieGenreState _state = MovieGenreState();
  // MovieGenreState get state => _state;

  final _pagingController = PagingController<int, Movie>(firstPageKey: 1);
  PagingController<int, Movie> get pagingController => _pagingController;

  MovieGenreViewModel(this._getMovieWithGenreUseCase, this._genre) {
    _pagingController.addPageRequestListener(_loadMovie);
  }

  Future<void> _loadMovie(int page) async {
    final result = await _getMovieWithGenreUseCase(
        Param.movieWithGenre(_genre.id, page: page));

    result.when(success: (pageResult) {
      final isLastPage = pageResult.isLastPage;
      final newItems = pageResult.items;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        _pagingController.appendPage(newItems, page + 1);
      }
    }, error: (message) {
      _pagingController.error = '불러오기 실패';
    });
  }
}

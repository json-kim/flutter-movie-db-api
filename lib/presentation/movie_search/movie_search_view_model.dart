import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:movie_search/data/tmdb_api.dart';
import 'package:movie_search/model/genre.dart';
import 'package:movie_search/model/movie.dart';

class MovieSearchViewModel with ChangeNotifier {
  final TMDBApi movieDBApi;
  List<Movie> _loadedMovies = [];
  List<Genre> _loadedGenres = [];
  Genre currentGenre = const Genre(id: 28, name: '액션');
  int _currentPage = 1;
  UnmodifiableListView<Movie> get movies => UnmodifiableListView(_loadedMovies);
  UnmodifiableListView<Genre> get genres => UnmodifiableListView(_loadedGenres);
  bool isLoading = false;
  bool isMoreLoading = false;

  MovieSearchViewModel({required this.movieDBApi}) {
    initMovieData();
  }

  void loadingStateChange(bool newState) {
    isLoading = newState;
    notifyListeners();
  }

  void genreChange(Genre genre) {
    currentGenre = genre;
    _currentPage = 1;
  }

  Future<void> initMovieData() async {
    getMoviesPopular();
    getGenres();
  }

  Future<void> getMoviesPopular() async {
    loadingStateChange(true);

    final movies = await movieDBApi.fetchMoviesWithPage();
    _loadedMovies = movies;

    loadingStateChange(false);
  }

  Future<void> getMoviesWithQuery(String query) async {
    if (query.isEmpty) {
      return;
    }
    loadingStateChange(true);

    final movies = await movieDBApi.fetchMoviesWithQuery(query: query);
    _loadedMovies = movies;

    loadingStateChange(false);
  }

  Future<void> getGenres() async {
    final genres = await movieDBApi.fetchGenres();
    _loadedGenres = genres;
  }

  Future<void> getMoviesWithGenre({Genre? genre}) async {
    if (genre == null) {
      getMoreMoviesWithGenre(currentGenre, ++_currentPage);
    } else {
      genreChange(genre);
      loadingStateChange(true);

      final movies = await movieDBApi.fetchMoviesWithGenre(
          genre: genre, page: _currentPage);
      _loadedMovies = movies;

      loadingStateChange(false);
    }
  }

  Future<void> getMoreMoviesWithGenre(Genre genre, int page) async {
    isMoreLoading = true;
    notifyListeners();

    final movies =
        await movieDBApi.fetchMoviesWithGenre(genre: genre, page: page);
    _loadedMovies.addAll(movies);

    isMoreLoading = false;
    notifyListeners();
  }
}

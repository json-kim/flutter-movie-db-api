import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:movie_search/data/tmdb_api.dart';
import 'package:movie_search/model/genre.dart';
import 'package:movie_search/model/movie.dart';

class MovieSearchViewModel with ChangeNotifier {
  final TMDBApi movieDBApi;
  List<Movie> _loadedMovies = [];
  List<Genre> _loadedGenres = [];
  UnmodifiableListView<Movie> get movies => UnmodifiableListView(_loadedMovies);
  UnmodifiableListView<Genre> get genres => UnmodifiableListView(_loadedGenres);
  bool isLoading = false;

  MovieSearchViewModel({required this.movieDBApi}) {
    initMovieData();
  }

  void loadingStateChange(bool state) {
    isLoading = state;
    notifyListeners();
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
    loadingStateChange(true);

    final movies = await movieDBApi.fetchMoviesWithQuery(query: query);
    _loadedMovies = movies;

    loadingStateChange(false);
  }

  Future<void> getGenres() async {
    final genres = await movieDBApi.fetchGenres();
    _loadedGenres = genres;
  }

  Future<void> getMoviesWithGenre(Genre genre) async {
    loadingStateChange(true);

    final movies = await movieDBApi.fetchMoviesWithGenre(genre: genre);
    _loadedMovies = movies;

    loadingStateChange(false);
  }
}

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:movie_search/data/tmdb_api.dart';
import 'package:movie_search/model/movie.dart';

class MovieHomeViewModel with ChangeNotifier {
  final TMDBApi _tmdbApi;

  List<Movie> _nowPlayingMovies = [];
  UnmodifiableListView<Movie> get nowPlayingMovies =>
      UnmodifiableListView<Movie>(_nowPlayingMovies);

  MovieHomeViewModel({required TMDBApi tmdbApi}) : _tmdbApi = tmdbApi {
    loadNowPlayingMovies();
  }

  Future<void> loadNowPlayingMovies() async {
    final movies = await _tmdbApi.fetchNowPlayingMovies();

    _nowPlayingMovies = movies;

    notifyListeners();
  }
}

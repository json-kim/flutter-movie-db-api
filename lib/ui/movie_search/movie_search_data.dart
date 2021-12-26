import 'package:movie_search/data/the_movie_db_api.dart';
import 'package:movie_search/model/genre.dart';
import 'package:movie_search/model/movie.dart';

class MovieSearchData {
  final TheMovieDBApi _movieDBApi = TheMovieDBApi();
  List<Movie> _loadedMovies = [];
  List<Movie> get movies => [..._loadedMovies];
  bool isLoading = false;

  Future<void> initMovieData() async {
    int totalPage = await _movieDBApi.fetchTotalPage();

    _loadedMovies = await getAllMovies(totalPage);
  }

  Future<List<Movie>> getAllMovies(int totalPage) async {
    List<Movie> movies = [];
    for (int i = 0; i < 5; i++) {
      final moviesOfPage = await _movieDBApi.fetchMoviesWithPage(page: i + 1);
      movies.addAll(moviesOfPage);
    }
    return movies;
  }

  Future<List<Movie>> getMoviesWithQuery(String query) async {
    final movies = await _movieDBApi.fetchMoviesWithQuery(query: query);
    return movies;
  }

  Future<List<Genre>> getGenres() async {
    final genres = await _movieDBApi.fetchGenres();
    return genres;
  }

  Future<List<Movie>> getMoviesWithGenre(Genre genre) async {
    final movies = await _movieDBApi.fetchMoviesWithGenre(genre: genre);

    return movies;
  }
}

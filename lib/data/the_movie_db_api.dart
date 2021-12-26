import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_search/model/genre.dart';

import '../model/movie.dart';

class TheMovieDBApi {
  final subject = 'popular';
  final apiKey = 'bb7dc78e99a7426412596173e43a6781';

  // 페이지를 가지고 영화 정보 가져오
  Future<List<Movie>> fetchMoviesWithPage({int page = 1}) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$subject?api_key=$apiKey&language=ko-KR&page=$page'));

    if (response.statusCode == 200) {
      return Movie.listToMovies(jsonDecode(response.body)['results']);
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<int> fetchTotalPage() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=bb7dc78e99a7426412596173e43a6781&language=ko-KR'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['total_pages'] as int;
    } else {
      throw Exception('Failed to load total_pages');
    }
  }

  // 쿼리로 영화 정보 검색하여 가져오기
  Future<List<Movie>> fetchMoviesWithQuery({required String query}) async {
    // query가 빈 문자열일 경우 popular movie 데이터 가져오기
    final url = query.isEmpty
        ? 'https://api.themoviedb.org/3/movie/popular?api_key=bb7dc78e99a7426412596173e43a6781&language=ko-KR'
        : 'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&query=$query&language=ko-KR';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Movie.listToMovies(jsonDecode(response.body)['results']);
    } else {
      throw Exception('Failed to search movies');
    }
  }

  // 전체 장르 정보 가져오기
  Future<List<Genre>> fetchGenres() async {
    final url =
        'https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey&language=ko-KR';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Genre.listToGenres(jsonDecode(response.body)['genres']);
    } else {
      throw Exception('Failed to load genres');
    }
  }

  // 장르 id를 가지고 영화 정보 가져오기
  Future<List<Movie>> fetchMoviesWithGenre(
      {required Genre genre, int page = 1}) async {
    final url =
        'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&with_genres=${genre.id}&page=$page&language=ko-KR';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Movie.listToMovies(jsonDecode(response.body)['results']);
    } else {
      throw Exception('Failed to load movies with genre');
    }
  }
}

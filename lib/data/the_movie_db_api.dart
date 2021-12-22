import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/movie.dart';

class TheMovieDBApi {
  final subject = 'popular';
  final apiKey = 'bb7dc78e99a7426412596173e43a6781';

  Future<List<Movie>> fetchMoviesWithPage(int page) async {
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

  Future<List<Movie>> fetchMoviesWithQuery(String query) async {
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
}

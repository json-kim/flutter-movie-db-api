import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_search/model/genre.dart';
import 'package:movie_search/model/movie.dart';
import 'package:movie_search/ui/movie_detail/movie_detail_screen.dart';
import 'package:movie_search/ui/movie_search/movie_search_data.dart';

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({Key? key}) : super(key: key);

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  final MovieSearchData _movieSearchData = MovieSearchData();
  final TextEditingController _textEditingController = TextEditingController();
  List<Movie> _movies = [];
  List<Genre> _genres = [];
  Timer? _debounce;
  Genre _value = Genre(id: 28, name: '액션'); // 액션 장르 id

  Future<void> getAllMovies() async {
    await _movieSearchData.initMovieData();

    setState(() {
      _movies = _movieSearchData.movies;
    });
  }

  Future<void> getGenres() async {
    _genres = await _movieSearchData.getGenres();
    setState(() {});
  }

  Future<void> searchMoviesWithQuery(String query) async {
    _movies = await _movieSearchData.getMoviesWithQuery(query);
    setState(() {});
  }

  Future<void> searchMoviesWithGenre(Genre genre) async {
    _movies = await _movieSearchData.getMoviesWithGenre(genre);
    setState(() {});
  }

  // 디바운싱 처리
  void onQueryChanged(String query) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce = Timer(
        const Duration(milliseconds: 500), () => searchMoviesWithQuery(query));
  }

  @override
  void initState() {
    getGenres();
    getAllMovies();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('영화 정보 검색기'),
      ),
      body: Column(
        children: [
          TextField(
            style: const TextStyle(color: Colors.white),
            controller: _textEditingController,
            cursorColor: Colors.white,
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              suffixIcon: IconButton(
                icon: const Text(
                  '검색',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  final query = _textEditingController.text;
                  searchMoviesWithQuery(query);
                },
              ),
            ),
            onChanged: onQueryChanged,
          ),
          DropdownButton<Genre>(
              style: const TextStyle(color: Colors.white),
              dropdownColor: Colors.black,
              value: _value,
              isExpanded: true,
              items: _genres
                  .map((e) =>
                      DropdownMenuItem<Genre>(value: e, child: Text(e.name)))
                  .toList(),
              onChanged: (value) => setState(() {
                    _value = value ?? Genre(id: 28, name: '액션');
                    searchMoviesWithGenre(_value);
                  })),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.5,
              ),
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(
                          movie: _movies[index],
                        ),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 8,
                        fit: FlexFit.tight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: _movies[index].posterPath.isEmpty
                              ? Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'no image',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Image.network(
                                  _movies[index].posterUrl,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Center(
                          child: Text(
                            _movies[index].title,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                overflow: TextOverflow.fade),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

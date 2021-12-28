import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_search/model/genre.dart';
import 'package:movie_search/ui/movie_search/movie_search_view_model.dart';
import 'package:provider/src/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'components/movie_grid_view_card.dart';

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({Key? key}) : super(key: key);

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  Timer? _debounce;

  // 디바운싱 처리
  void onQueryChanged(
      {required ValueChanged<String> searchMovie, required String query}) {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }

    _debounce =
        Timer(const Duration(milliseconds: 500), () => searchMovie(query));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _refreshController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MovieSearchViewModel>();

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
            autofocus: false,
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
                  context
                      .read<MovieSearchViewModel>()
                      .getMoviesWithQuery(query);
                },
              ),
            ),
            onChanged: (value) => onQueryChanged(
              searchMovie: (query) {
                context.read<MovieSearchViewModel>().getMoviesWithQuery(query);
              },
              query: value,
            ),
          ),
          DropdownButton<Genre>(
              style: const TextStyle(color: Colors.white),
              dropdownColor: Colors.black,
              value: viewModel.currentGenre,
              isExpanded: true,
              menuMaxHeight: 250,
              items: viewModel.genres
                  .map((e) =>
                      DropdownMenuItem<Genre>(value: e, child: Text(e.name)))
                  .toList(),
              onChanged: (value) {
                context
                    .read<MovieSearchViewModel>()
                    .getMoviesWithGenre(genre: value);
              }),
          Expanded(
            child: viewModel.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: true,
                    enablePullDown: false,
                    footer: CustomFooter(
                      height: viewModel.isMoreLoading ? 55 : 0,
                      builder: (context, mode) {
                        if (mode == LoadStatus.loading) {
                          return Container(
                            height: 55.0,
                            child: const Center(
                                child: CircularProgressIndicator()),
                          );
                        }
                        return Container();
                      },
                    ),
                    onLoading: () async {
                      // TODO: 영화정보를 더 가져오는게 쿼리 검색에서 더 가져오는지, 장르 검색에서 더 가져오는 구분 x
                      // 구분하여 실행하는 과정 필요
                      await viewModel.getMoviesWithGenre();
                      _refreshController.loadComplete();
                    },
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.5,
                      ),
                      itemCount: viewModel.movies.length,
                      itemBuilder: (context, index) {
                        final movie = viewModel.movies[index];

                        return MovieGridViewCard(movie: movie);
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

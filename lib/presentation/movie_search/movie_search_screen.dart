import 'dart:async';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/usecase/bookmark/delete_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/find_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/save_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_detail_use_case.dart';
import 'package:movie_search/domain/usecase/review/delete_review_use_case.dart';
import 'package:movie_search/domain/usecase/review/get_review_by_movie_use_case.dart';
import 'package:movie_search/presentation/global_components/movie_data_card.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_screen.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_view_model.dart';
import 'package:movie_search/presentation/movie_search/movie_search_event.dart';
import 'package:movie_search/presentation/movie_search/movie_search_view_model.dart';
import 'package:movie_search/ui/navigator_key.dart';
import 'package:movie_search/ui/theme.dart';
import 'package:provider/provider.dart';

class MovieSearchScreen extends StatefulWidget {
  const MovieSearchScreen({Key? key}) : super(key: key);

  @override
  State<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends State<MovieSearchScreen>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _textEditingController = TextEditingController();
  Timer? _debounce;

  @override
  bool get wantKeepAlive => true;

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
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MovieSearchViewModel>();
    final state = viewModel.state;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('영화 검색'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              autofocus: false,
              style: const TextStyle(color: whiteColor),
              controller: _textEditingController,
              cursorColor: whiteColor,
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: whiteColor)),
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: whiteColor)),
                suffixIcon: IconButton(
                  icon: const Text(
                    '검색',
                  ),
                  onPressed: () {
                    final query = _textEditingController.text;
                    viewModel.onEvent(MovieSearchEvent.search(query: query));
                  },
                ),
              ),
              onChanged: (value) => onQueryChanged(
                searchMovie: (query) {
                  viewModel.onEvent(MovieSearchEvent.search(query: query));
                },
                query: value,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              child: PagedGridView(
                pagingController: viewModel.pagingController,
                builderDelegate: PagedChildBuilderDelegate<Movie>(
                  noItemsFoundIndicatorBuilder: (context) => Column(
                    children: const [
                      Text('검색 기록'),
                    ],
                  ),
                  firstPageErrorIndicatorBuilder: (context) =>
                      const Center(child: Text('검색 실패')),
                  newPageErrorIndicatorBuilder: (context) =>
                      const Center(child: Text('검색 실패')),
                  itemBuilder: (context, movie, index) => MovieDataCard(
                    url: movie.posterPath == null
                        ? null
                        : kPosterUrl + movie.posterPath!,
                    title: movie.title,
                    titleColor: Colors.white,
                    onCardTap: () {
                      Navigator.of(
                              NavigatorKey.navigatorKeyMain.currentContext!)
                          .push(
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (context) => MovieDetailViewModel(
                              context.read<GetMovieDetailUseCase>(),
                              context.read<FindBookmarkDataUseCase<Movie>>(),
                              context.read<SaveBookmarkDataUseCase<Movie>>(),
                              context.read<DeleteBookmarkDataUseCase<Movie>>(),
                              context.read<GetReviewByMovieUseCase>(),
                              context.read<DeleteReviewUseCase>(),
                              movieId: movie.id,
                            ),
                            child: const MovieDetailScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 0.5,
                ),
              ),
              onRefresh: () async {
                viewModel.pagingController.refresh();
              },
            ),
          ),
        ],
      ),
    );
  }
}

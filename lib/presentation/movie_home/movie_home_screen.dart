import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/usecase/bookmark/delete_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/find_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/save_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_detail_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_popular_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_with_genre_use_case.dart';
import 'package:movie_search/domain/usecase/review/delete_review_use_case.dart';
import 'package:movie_search/domain/usecase/review/get_review_by_movie_use_case.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_screen.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_view_model.dart';
import 'package:movie_search/presentation/movie_genre/movie_genre_screen.dart';
import 'package:movie_search/presentation/movie_genre/movie_genre_view_model.dart';
import 'package:movie_search/presentation/movie_list/data_list_view_model.dart';
import 'package:movie_search/ui/navigator_key.dart';
import 'package:provider/provider.dart';

import 'component/movie_page_card.dart';
import 'component/sliver_movie_list.dart';
import 'movie_home_event.dart';
import 'movie_home_view_model.dart';

class MovieHomeScreen extends StatefulWidget {
  const MovieHomeScreen({Key? key}) : super(key: key);

  @override
  State<MovieHomeScreen> createState() => _MovieHomeScreenState();
}

class _MovieHomeScreenState extends State<MovieHomeScreen>
    with AutomaticKeepAliveClientMixin {
  int _currentPage = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MovieHomeViewModel>();

    return Scaffold(
      body: _buildBody(viewModel),
    );
  }

  Widget _buildBody(MovieHomeViewModel viewModel) {
    final state = viewModel.state;

    return RefreshIndicator(
      onRefresh: () async {
        viewModel.onEvent(const MovieHomeEvent.load());
      },
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                SizedBox(
                  height: 500,
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : PageView.builder(
                          onPageChanged: (page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          scrollDirection: Axis.horizontal,
                          itemCount: state.nowPlayingMovies.length,
                          itemBuilder: (context, idx) {
                            return MoviePageCard(
                              movie: state.nowPlayingMovies[idx],
                              onTap: () {
                                Navigator.of(NavigatorKey
                                        .navigatorKeyMain.currentContext!)
                                    .push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider(
                                      create: (context) => MovieDetailViewModel(
                                        context.read<GetMovieDetailUseCase>(),
                                        context.read<
                                            FindBookmarkDataUseCase<Movie>>(),
                                        context.read<
                                            SaveBookmarkDataUseCase<Movie>>(),
                                        context.read<
                                            DeleteBookmarkDataUseCase<Movie>>(),
                                        context.read<GetReviewByMovieUseCase>(),
                                        context.read<DeleteReviewUseCase>(),
                                        movieId: state.nowPlayingMovies[idx].id,
                                      ),
                                      child: const MovieDetailScreen(),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
                Positioned(
                  bottom: 4,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                        viewModel.state.nowPlayingMovies.length,
                        (index) => index == _currentPage
                            ? Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                height: 4,
                                width: 4,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                height: 1,
                                width: 4,
                                color: Colors.white,
                              )),
                  ),
                ),
              ],
            ),
          ),
          ...viewModel.state.genreList
              .map(
                (genre) => ChangeNotifierProvider(
                  create: (context) => DataPageViewModel<Movie, Param>(
                      context.read<GetMovieWithGenreUseCase>(),
                      Param.movieWithGenre(genre.id)),
                  child: SliverMovieList(
                    title: genre.name,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (context) => MovieGenreViewModel(
                                context.read<GetMovieWithGenreUseCase>(),
                                genre),
                            child: const MovieGenreScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}

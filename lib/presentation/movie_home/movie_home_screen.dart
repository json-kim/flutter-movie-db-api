import 'package:flutter/material.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/entity/genre/genre.dart';
import 'package:movie_search/domain/usecase/get_movie_popular_use_case.dart';
import 'package:movie_search/domain/usecase/get_movie_with_genre_use_case.dart';
import 'package:movie_search/presentation/movie_home/component/sliver_movie_list_view_model.dart';
import 'package:provider/provider.dart';

import 'component/sliver_movie_list.dart';
import 'movie_home_view_model.dart';

class MovieHomeScreen extends StatefulWidget {
  const MovieHomeScreen({Key? key}) : super(key: key);

  @override
  State<MovieHomeScreen> createState() => _MovieHomeScreenState();
}

class _MovieHomeScreenState extends State<MovieHomeScreen>
    with AutomaticKeepAliveClientMixin {
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
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 500,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.state.nowPlayingMovies.length,
              itemBuilder: (context, idx) {
                final movie = viewModel.state.nowPlayingMovies[idx];
                return Stack(
                  children: [
                    SizedBox.expand(
                      child: Image.network(
                        kBackdropUrl + movie.backdropPath!,
                        // movie.posterUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black,
                            offset: Offset(0, 350),
                            blurRadius: 50,
                            spreadRadius: 50,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(movie.title,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          Text(movie.originalTitle),
                          const SizedBox(height: 8),
                          Text(
                            movie.overview,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 16,
                      child: Container(
                          color: Colors.pink,
                          child: Text('평점: ${movie.voteAverage}')),
                    )
                  ],
                );
              },
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              SliverMovieListViewModel<GetMoviePopularUseCase, void>(
            context.read<GetMoviePopularUseCase>(),
          ),
          child: SliverMovieList<GetMoviePopularUseCase, void>(
            title: '인기몰이 영화',
          ),
        ),
        ...viewModel.state.genreList
            .map((genre) => ChangeNotifierProvider(
                create: (context) =>
                    SliverMovieListViewModel<GetMovieWithGenreUseCase, Genre>(
                        context.read<GetMovieWithGenreUseCase>(),
                        data: genre),
                child: SliverMovieList<GetMovieWithGenreUseCase, Genre>(
                    title: genre.name)))
            .toList(),
      ],
    );
  }
}

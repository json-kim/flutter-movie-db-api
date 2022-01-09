import 'package:flutter/material.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/entity/genre/genre.dart';
import 'package:movie_search/domain/entity/movie/movie.dart';
import 'package:movie_search/domain/usecase/get_movie_detail_use_case.dart';
import 'package:movie_search/domain/usecase/get_movie_popular_use_case.dart';
import 'package:movie_search/domain/usecase/get_movie_with_genre_use_case.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_screen.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_view_model.dart';
import 'package:movie_search/presentation/movie_list/data_list_view_model.dart';
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
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Stack(
            children: [
              SizedBox(
                height: 500,
                child: PageView.builder(
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.state.nowPlayingMovies.length,
                  itemBuilder: (context, idx) {
                    return MoviePageCard(
                        movie: viewModel.state.nowPlayingMovies[idx]);
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
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 4,
                              width: 4,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              height: 1,
                              width: 4,
                              color: Colors.white,
                            )),
                ),
              ),
            ],
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => DataListViewModel<Movie, void>(
            context.read<GetMoviePopularUseCase>(),
            1,
          ),
          child: const SliverMovieList<void>(
            title: '인기몰이 영화',
          ),
        ),
        ...viewModel.state.genreList
            .map((genre) => ChangeNotifierProvider(
                create: (context) => DataListViewModel<Movie, Genre>(
                    context.read<GetMovieWithGenreUseCase>(), genre),
                child: SliverMovieList<Genre>(title: genre.name)))
            .toList(),
      ],
    );
  }
}

class MoviePageCard extends StatelessWidget {
  const MoviePageCard({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
                  create: (context) => MovieDetailViewModel(
                    context.read<GetMovieDetailUseCase>(),
                    movie: movie,
                  ),
                  child: MovieDetailScreen(),
                )));
      },
      child: Stack(
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('평점: ${movie.voteAverage}')),
          )
        ],
      ),
    );
  }
}

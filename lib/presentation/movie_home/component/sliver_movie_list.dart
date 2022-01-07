import 'package:flutter/material.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/entity/movie/movie.dart';
import 'package:movie_search/domain/usecase/get_credit_with_movie_use_case.dart';
import 'package:movie_search/domain/usecase/get_movie_detail_use_case.dart';
import 'package:movie_search/domain/usecase/use_case.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_screen.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_view_model.dart';
import 'package:movie_search/presentation/movie_home/component/sliver_movie_list_view_model.dart';
import 'package:provider/provider.dart';

class SliverMovieList<T extends UseCase, S> extends StatelessWidget {
  final String title;

  const SliverMovieList({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SliverMovieListViewModel<T, S>>();
    final movies = viewModel.state.movies;

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        height: 300,
        color: Colors.black,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16),
                  ),
                  IconButton(
                      iconSize: 14,
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_forward_ios))
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, idx) =>
                    MovieListCard(movie: movies[idx]),
                itemCount: movies.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MovieListCard extends StatelessWidget {
  const MovieListCard({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                    create: (context) => MovieDetailViewModel(
                      context.read<GetMovieDetailUseCase>(),
                      context.read<GetCreditWithMovieUseCase>(),
                      movieId: movie.id,
                    ),
                    child: MovieDetailScreen(),
                  )),
        );
      },
      child: SizedBox(
        width: 115,
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                kPosterUrl + movie.posterPath!,
                fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  movie.title,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

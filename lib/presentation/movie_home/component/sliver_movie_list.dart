import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/entity/movie/movie.dart';
import 'package:movie_search/domain/usecase/get_movie_detail_use_case.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_screen.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_view_model.dart';
import 'package:movie_search/presentation/movie_list/data_list_view_model.dart';
import 'package:provider/provider.dart';

class SliverMovieList<P> extends StatelessWidget {
  final String title;

  const SliverMovieList({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DataListViewModel<Movie, P>>();
    final state = viewModel.state;

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
                    MovieListCard(movie: state.data[idx]),
                itemCount: state.data.length,
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
                      movie: movie,
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
              child: CachedNetworkImage(
                imageUrl: kPosterUrl + movie.posterPath!,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
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

import 'package:flutter/material.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/usecase/bookmark/delete_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/find_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/save_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_detail_use_case.dart';
import 'package:movie_search/presentation/global_components/movie_data_card.dart';
import 'package:movie_search/presentation/movie_bookmark/movie_bookmark_event.dart';
import 'package:movie_search/presentation/movie_bookmark/movie_bookmark_view_model.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_screen.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_view_model.dart';
import 'package:provider/provider.dart';

class MovieBookmarkScreen extends StatefulWidget {
  const MovieBookmarkScreen({Key? key}) : super(key: key);

  @override
  State<MovieBookmarkScreen> createState() => _MovieBookmarkScreenState();
}

class _MovieBookmarkScreenState extends State<MovieBookmarkScreen> {
  @override
  void initState() {
    Future.microtask(() {
      context
          .read<MovieBookmarkViewModel>()
          .onEvent(const MovieBookmarkEvent.load());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MovieBookmarkViewModel>();
    final state = viewModel.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('북마크'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1 / 1.8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: state.bookmarkMovies.length,
        itemBuilder: (context, idx) {
          final movie = state.bookmarkMovies[idx];
          return MovieDataCard(
              url: movie.posterPath == null
                  ? null
                  : kPosterUrl + movie.posterPath!,
              title: movie.title,
              titleColor: Colors.white,
              onCardTap: () {
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (context) => MovieDetailViewModel(
                              context.read<GetMovieDetailUseCase>(),
                              context.read<FindBookmarkDataUseCase<Movie>>(),
                              context.read<SaveBookmarkDataUseCase<Movie>>(),
                              context.read<DeleteBookmarkDataUseCase<Movie>>(),
                              movieId: movie.id),
                          child: const MovieDetailScreen(),
                        ),
                      ),
                    )
                    .then((_) =>
                        viewModel.onEvent(const MovieBookmarkEvent.load()));
              });
        },
      ),
    );
  }
}

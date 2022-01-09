import 'package:flutter/material.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/entity/movie/movie.dart';
import 'package:movie_search/domain/usecase/get_movie_detail_use_case.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_screen.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_view_model.dart';
import 'package:movie_search/presentation/movie_list/data_list_view_model.dart';
import 'package:provider/provider.dart';

class SimilarSliverGrid extends StatelessWidget {
  const SimilarSliverGrid({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DataListViewModel<Movie, Movie>>();
    final state = viewModel.state;

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
          delegate: SliverChildBuilderDelegate(
            (context, index) => GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChangeNotifierProvider(
                          create: (context) => MovieDetailViewModel(
                              context.read<GetMovieDetailUseCase>(),
                              movie: state.data[index]),
                          child: const MovieDetailScreen(),
                        )));
              },
              child: state.data[index].posterPath == null
                  ? Center(
                      child: Text(state.data[index].title),
                    )
                  : Image.network(
                      kPosterUrl + state.data[index].posterPath!,
                      fit: BoxFit.cover,
                    ),
            ),
            childCount: state.data.length,
          ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1 / 1.6)),
    );
  }
}

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
import 'package:provider/provider.dart';

import 'movie_genre_view_model.dart';

class MovieGenreScreen extends StatelessWidget {
  const MovieGenreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MovieGenreViewModel>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(viewModel.genre.name),
      ),
      body: RefreshIndicator(
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
                Navigator.of(context).push(
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
    );
  }
}

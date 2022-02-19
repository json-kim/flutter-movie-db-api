import 'package:flutter/material.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/usecase/bookmark/delete_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/find_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/save_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_detail_use_case.dart';
import 'package:movie_search/domain/usecase/review/delete_review_use_case.dart';
import 'package:movie_search/domain/usecase/review/get_review_by_movie_use_case.dart';
import 'package:movie_search/presentation/global_components/movie_data_card.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_view_model.dart';
import 'package:movie_search/presentation/movie_detail/movie_nested_screen.dart';
import 'package:movie_search/ui/navigator_key.dart';
import 'package:provider/provider.dart';

class BookmarkGrid extends StatelessWidget {
  const BookmarkGrid({
    Key? key,
    required this.movies,
    required this.popCallBack,
  }) : super(key: key);

  final List<Movie> movies;
  final void Function() popCallBack;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1 / 1.8,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: movies.length,
      itemBuilder: (context, idx) {
        final movie = movies[idx];
        return MovieDataCard(
            url: movie.posterPath == null
                ? null
                : kPosterUrl + movie.posterPath!,
            title: movie.title,
            titleColor: Colors.white,
            onCardTap: () {
              Navigator.of(NavigatorKey.navigatorKeyMain.currentContext!)
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
                            movieId: movie.id),
                        child: MovieNestedScreen(
                            navigatorKey: GlobalKey<NavigatorState>()),
                      ),
                    ),
                  )
                  .then((_) => popCallBack());
            });
      },
    );
  }
}

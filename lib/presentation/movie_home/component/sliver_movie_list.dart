import 'package:flutter/material.dart';
import 'package:movie_search/core/param/param.dart';
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
import 'package:movie_search/presentation/movie_list/data_list_view_model.dart';
import 'package:movie_search/ui/navigator_key.dart';
import 'package:provider/provider.dart';

class SliverMovieList extends StatelessWidget {
  final String title;

  const SliverMovieList({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<DataPageViewModel<Movie, Param>>();
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
                  const Spacer(),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      children: const [
                        Text(
                          '전체보기',
                          style: TextStyle(fontSize: 13),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, idx) => MovieDataCard(
                        title: state.data[idx].title,
                        url: state.data[idx].posterPath == null
                            ? null
                            : kPosterUrl + state.data[idx].posterPath!,
                        width: 115,
                        titleColor: Colors.white,
                        onCardTap: () {
                          Navigator.of(
                                  NavigatorKey.navigatorKeyMain.currentContext!)
                              .push(
                            MaterialPageRoute(
                              builder: (context) => ChangeNotifierProvider(
                                create: (context) => MovieDetailViewModel(
                                  context.read<GetMovieDetailUseCase>(),
                                  context
                                      .read<FindBookmarkDataUseCase<Movie>>(),
                                  context
                                      .read<SaveBookmarkDataUseCase<Movie>>(),
                                  context
                                      .read<DeleteBookmarkDataUseCase<Movie>>(),
                                  context.read<GetReviewByMovieUseCase>(),
                                  context.read<DeleteReviewUseCase>(),
                                  movieId: state.data[idx].id,
                                ),
                                child: const MovieDetailScreen(),
                              ),
                            ),
                          );
                        },
                      ),
                      itemCount: state.data.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

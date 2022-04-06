import 'dart:async';
import 'dart:math';

import 'package:auto_animated/auto_animated.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:movie_search/presentation/movie_detail/movie_detail_screen.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_view_model.dart';
import 'package:movie_search/presentation/movie_soon/movie_soon_event.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dart_date/dart_date.dart';
import 'package:provider/provider.dart';

import 'movie_soon_view_model.dart';

class MovieSoonScreen extends StatefulWidget {
  const MovieSoonScreen({Key? key}) : super(key: key);

  @override
  State<MovieSoonScreen> createState() => _MovieSoonScreenState();
}

class _MovieSoonScreenState extends State<MovieSoonScreen> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    Future.microtask(() async {
      final viewModel = context.read<MovieSoonViewModel>();

      _subscription = viewModel.uiEventStream.listen((event) {
        event.when(snackBar: (message) {
          final snackBar = SnackBar(
              content: Text(message), behavior: SnackBarBehavior.floating);

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MovieSoonViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('공개 예정'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          AnimateIfVisibleWrapper(
            child: RefreshIndicator(
              child: PagedListView(
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
                  itemBuilder: (context, movie, index) => AnimateIfVisible(
                    visibleFraction: 0.15,
                    key: ValueKey(movie.id),
                    duration: Duration(milliseconds: 500),
                    builder: (context, animation) => FadeTransition(
                      opacity: Tween<double>(
                        begin: 0,
                        end: 1,
                      ).animate(animation),
                      // And slide transition
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(animation),
                        // Paste you Widget
                        child: UpcomingMovieCard(
                          movie: movie,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              onRefresh: () async {
                viewModel.pagingController.refresh();
              },
            ),
          ),
          if (viewModel.state.isLoading)
            Container(
              alignment: Alignment.center,
              color: Colors.transparent,
              child: CircularProgressIndicator(),
            )
        ],
      ),
    );
  }
}

class UpcomingMovieCard extends StatelessWidget {
  final Movie movie;

  const UpcomingMovieCard({
    required this.movie,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MovieSoonViewModel>();

    return SizedBox(
      height: max(60.h, 500),
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: InkWell(
              onTap: () {
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
              child: movie.backdropPath == null
                  ? CachedNetworkImage(
                      imageUrl: kPosterUrl + movie.posterPath!,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    )
                  : CachedNetworkImage(
                      imageUrl: kBackdropUrl + movie.backdropPath!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              movie.title,
                              style: TextStyle(
                                  fontSize: 18.sp, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildAlarmButton(
                            movie.releaseDate,
                            viewModel.isAlarmed(movie.id),
                            () {
                              viewModel.onEvent(MovieSoonEvent.alarm(movie));
                            },
                          ),
                        ],
                      ),
                    )),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${movie.releaseDate ?? '조만간'} 공개됩니다.',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          movie.overview,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmButton(
      String? releaseDate, bool isAlarmed, void Function() onPressed) {
    if (releaseDate == null) {
      return Text('날짜 미정');
    }

    final date = DateTime.parse(releaseDate);
    final diff = -date.differenceInDays(DateTime.now());
    // 오늘 공개
    if (diff == 0) {
      return Text('오늘 공개');
    } else if (diff > 0) {
      return Text('$diff일전 공개');
    } else {
      return IconButton(
        padding: EdgeInsets.all(4),
        onPressed: onPressed,
        icon: Column(
          children: [
            Icon(
              isAlarmed
                  ? Icons.notifications_active
                  : Icons.notifications_active_outlined,
              size: 20.sp,
            ),
            Text(
              '알람받기',
              style: TextStyle(fontSize: 11.sp),
            ),
          ],
        ),
      );
    }
  }
}

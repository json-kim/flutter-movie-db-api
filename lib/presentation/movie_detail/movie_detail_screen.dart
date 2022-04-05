import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:movie_search/core/param/param.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/model/credit/credit.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/model/movie_detail/movie_detail.dart';
import 'package:movie_search/domain/model/video/video.dart';
import 'package:movie_search/domain/usecase/credit/get_credit_with_movie_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_similar_use_case.dart';
import 'package:movie_search/domain/usecase/review/create_review_use_case.dart';
import 'package:movie_search/domain/usecase/review/get_review_by_movie_use_case.dart';
import 'package:movie_search/domain/usecase/video/get_video_with_movie_use_case.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_event.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_view_model.dart';
import 'package:movie_search/presentation/movie_list/data_list_view_model.dart';
import 'package:movie_search/presentation/review_edit/review_edit_screen.dart';
import 'package:movie_search/presentation/review_edit/review_edit_view_model.dart';
import 'package:movie_search/ui/navigator_key.dart';
import 'package:movie_search/ui/theme.dart';
import 'package:provider/provider.dart';

import 'component/credit_sliver_list.dart';
import 'component/similar_sliver_list.dart';
import 'component/sliver_fixed_header.dart';
import 'component/video_sliver_list.dart';

class MovieDetailScreen extends StatefulWidget {
  const MovieDetailScreen({Key? key}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final viewModel = context.read<MovieDetailViewModel>();

      _subscription = viewModel.stream.listen((event) {
        event.when(snackBar: (message) {
          final snackBar = SnackBar(
              content: Text(message), behavior: SnackBarBehavior.floating);
          _scaffoldMessengerKey.currentState
            ?..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        });
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MovieDetailViewModel>();
    final state = viewModel.state;
    final review = state.review;
    final movieDetail = state.movieDetail;
    final size = MediaQuery.of(context).size;

    if (state.isLoading || movieDetail == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return ScaffoldMessenger(
        key: _scaffoldMessengerKey,
        child: Scaffold(
          body: Scaffold(
            backgroundColor: whiteColor,
            floatingActionButton: FabCircularMenu(
              ringColor: Colors.black.withOpacity(0.7),
              fabColor: whiteColor,
              fabOpenIcon: const Icon(Icons.edit, color: Colors.black),
              fabCloseIcon: const Icon(Icons.close, color: Colors.black),
              children: [
                TextButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChangeNotifierProvider(
                            create: (context) => ReviewEditViewModel(
                              context.read<CreateReviewUseCase>(),
                              context.read<GetReviewByMovieUseCase>(),
                              review: review,
                              movieDetail: movieDetail,
                              isEditMode: true,
                            ),
                            child: ReviewEditScreen(),
                          ),
                        ),
                      );

                      viewModel.onEvent(const MovieDetailEvent.loadReview());
                    },
                    child: const Text('리뷰 작성하기',
                        style: TextStyle(color: Colors.white))),
                TextButton(
                    onPressed: review == null
                        ? null
                        : () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) => ReviewEditViewModel(
                                    context.read<CreateReviewUseCase>(),
                                    context.read<GetReviewByMovieUseCase>(),
                                    review: review,
                                    isEditMode: false,
                                  ),
                                  child: ReviewEditScreen(),
                                ),
                              ),
                            );

                            viewModel
                                .onEvent(const MovieDetailEvent.loadReview());
                          },
                    child: Text('리뷰 확인하기',
                        style: TextStyle(
                            color: Colors.white
                                .withOpacity(review == null ? 0.3 : 1)))),
                TextButton(
                    onPressed: review == null
                        ? null
                        : () {
                            viewModel
                                .onEvent(const MovieDetailEvent.deleteReview());
                          },
                    child: Text('리뷰 삭제하기',
                        style: TextStyle(
                            color: Colors.white
                                .withOpacity(review == null ? 0.3 : 1)))),
              ],
            ),
            body: CustomScrollView(
              slivers: [
                // 앱바 (뒤로가기 버튼, 토글 버튼, 닫기 버튼)
                _buildAppBar(size, movieDetail, state.isBookmarked, () {
                  if (state.isToggle) {
                    return;
                  }

                  viewModel.onEvent(const MovieDetailEvent.toggleBookmark());
                }),

                // 영화 정보
                _buildMovieInfoBar(movieDetail),

                // 배우 제작진
                ChangeNotifierProvider(
                    create: (context) => DataListViewModel<Credit, Param>(
                          context.read<GetCreditWithMovieUseCase>(),
                          Param.creditWithMovie(viewModel.movieId),
                        ),
                    child: const CreditSliverList()),

                // 관련 영상
                ChangeNotifierProvider(
                    create: (context) => DataListViewModel<Video, Param>(
                          context.read<GetVideoWithMovieUseCase>(),
                          Param.videoWithMovie(viewModel.movieId),
                        ),
                    child: const VideoSliverList()),

                // 비슷한 영화
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      '비슷한 작품',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
                ChangeNotifierProvider(
                    create: (context) => DataPageViewModel<Movie, Param>(
                          context.read<GetMovieSimilarUseCase>(),
                          Param.movieSimilar(viewModel.movieId),
                        ),
                    child: const SimilarSliverGrid()),
              ],
            ),
          ),
        ),
      );
    }
  }
}

Widget _buildMovieInfoBar(MovieDetail movieDetail) {
  return SliverPersistentHeader(
    pinned: true,
    delegate: SliverFixedHeader(
      minHeight: 100,
      maxHeight: 100,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: whiteColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    child: Text(movieDetail.title,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 24)),
                  ),
                  FittedBox(
                    child: Text(movieDetail.originalTitle,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                  Expanded(child: Container()),
                  Row(
                    children: movieDetail.genres
                        .take(3)
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text('#' + e.name,
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 14)),
                          ),
                        )
                        .toList(),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16),
              padding: const EdgeInsets.all(10),
              color: Colors.blue,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text('평점'),
                  Text(movieDetail.voteAverage.toString()),
                  const Icon(
                    Icons.thumb_up,
                    size: 16,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget _buildAppBar(Size size, MovieDetail movieDetail, bool isBookmarked,
    void Function() onPressed) {
  return SliverAppBar(
    leading: IconButton(
        onPressed: () {
          Navigator.of(NavigatorKey.navigatorKeyMain.currentContext!).pop();
        },
        icon: const Icon(Icons.arrow_back_ios)),
    actions: [
      IconButton(
        icon: isBookmarked
            ? const Icon(Icons.bookmark_outlined)
            : const Icon(Icons.bookmark_outline),
        onPressed: onPressed,
      ),
      IconButton(
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.of(NavigatorKey.navigatorKeyMain.currentContext!)
              .popUntil((route) => route.isFirst);
        },
      ),
    ],
    collapsedHeight: size.height * 0.2,
    pinned: true,
    expandedHeight: size.height,
    elevation: 0,
    flexibleSpace: Stack(
      clipBehavior: Clip.none,
      children: [
        movieDetail.backdropPath == null
            ? CachedNetworkImage(
                imageUrl: kBackdropUrl + movieDetail.posterPath!,
                errorWidget: (context, url, error) =>
                    Container(color: Colors.black),
                fit: BoxFit.cover,
                height: size.height,
                width: size.width,
              )
            : CachedNetworkImage(
                imageUrl: kBackdropUrl + movieDetail.backdropPath!,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
                height: size.height,
                width: size.width,
              ),
        Container(
          color: Colors.black.withOpacity(0.5),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: size.height,
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxHeight < size.height * 0.75) {
                return Container();
              }
              return Container(
                height: constraints.maxHeight,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        movieDetail.title,
                        style: const TextStyle(
                          fontSize: 36,
                        ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('개봉일: ${movieDetail.releaseDate}'),
                              Row(
                                children: [
                                  ElevatedButton(
                                      onPressed: () {},
                                      child: Row(
                                        children: [
                                          const Icon(Icons.check),
                                          Text(
                                              movieDetail.voteCount.toString()),
                                        ],
                                      )),
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () {},
                                    child: Row(
                                      children: [
                                        const Icon(Icons.star),
                                        Text(
                                          movieDetail.voteAverage.toString(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Text(
                      movieDetail.overview ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                      maxLines: 7,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
        Positioned(
          bottom: -5,
          left: 0,
          right: 0,
          child: Container(
            height: 21,
            decoration: const BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16))),
          ),
        )
      ],
    ),
  );
}

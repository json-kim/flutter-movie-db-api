import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/model/review/review.dart';
import 'package:movie_search/domain/usecase/bookmark/delete_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/find_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/save_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/cast/get_cast_with_person_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_detail_use_case.dart';
import 'package:movie_search/domain/usecase/person/get_person_detail_use_case.dart';
import 'package:movie_search/domain/usecase/review/create_review_use_case.dart';
import 'package:movie_search/domain/usecase/review/delete_review_use_case.dart';
import 'package:movie_search/domain/usecase/review/get_review_by_movie_use_case.dart';
import 'package:movie_search/presentation/global_components/movie_data_card.dart';
import 'package:movie_search/presentation/global_components/person_data_card.dart';
import 'package:movie_search/presentation/movie_bookmark/movie_bookmark_event.dart';
import 'package:movie_search/presentation/movie_bookmark/movie_bookmark_view_model.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_screen.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_view_model.dart';
import 'package:movie_search/presentation/person_detail/person_detail_screen.dart';
import 'package:movie_search/presentation/person_detail/person_detail_view_model.dart';
import 'package:movie_search/presentation/review_edit/review_edit_screen.dart';
import 'package:movie_search/presentation/review_edit/review_edit_view_model.dart';
import 'package:movie_search/presentation/setting/setting_screen.dart';
import 'package:movie_search/ui/navigator_key.dart';
import 'package:movie_search/ui/theme.dart';
import 'package:provider/provider.dart';

import '../auth/auth_view_model.dart';

class MovieBookmarkScreen extends StatefulWidget {
  const MovieBookmarkScreen({Key? key}) : super(key: key);

  @override
  State<MovieBookmarkScreen> createState() => _MovieBookmarkScreenState();
}

class _MovieBookmarkScreenState extends State<MovieBookmarkScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  StreamSubscription? _subscription;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      final viewModel = context.read<MovieBookmarkViewModel>();

      _subscription = viewModel.uiEventStream.listen((event) {
        event.when(snackBar: (message) {
          final snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(message),
          );

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
    _tabController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MovieBookmarkViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('마이 노트'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              child: Text('영화'),
            ),
            Tab(
              child: Text('인물'),
            ),
            Tab(
              child: Text('마이 리뷰'),
            ),
          ],
        ),
        actions: [
          buildProfileButton(context),
        ],
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          // 영화 북마크 탭바뷰
          RefreshIndicator(
            onRefresh: () async {
              viewModel.moviePagingController.refresh();
            },
            child: PagedGridView(
              pagingController: viewModel.moviePagingController,
              padding: const EdgeInsets.all(8),
              builderDelegate: PagedChildBuilderDelegate<Movie>(
                itemBuilder: (context, movie, index) {
                  return MovieDataCard(
                      url: movie.posterPath == null
                          ? null
                          : kPosterUrl + movie.posterPath!,
                      title: movie.title,
                      titleColor: Colors.white,
                      onCardTap: () {
                        Navigator.of(
                                NavigatorKey.navigatorKeyMain.currentContext!)
                            .push(
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider(
                                  create: (context) => MovieDetailViewModel(
                                      context.read<GetMovieDetailUseCase>(),
                                      context.read<
                                          FindBookmarkDataUseCase<Movie>>(),
                                      context.read<
                                          SaveBookmarkDataUseCase<Movie>>(),
                                      context.read<
                                          DeleteBookmarkDataUseCase<Movie>>(),
                                      context.read<GetReviewByMovieUseCase>(),
                                      context.read<DeleteReviewUseCase>(),
                                      movieId: movie.id),
                                  child: const MovieDetailScreen(),
                                ),
                              ),
                            )
                            .then((_) =>
                                viewModel.moviePagingController.refresh());
                      });
                },
                noItemsFoundIndicatorBuilder: (context) => Column(
                  children: const [
                    Text('저장된 영화가 없습니다.'),
                  ],
                ),
                firstPageErrorIndicatorBuilder: (context) =>
                    const Center(child: Text('가져오기 실패')),
                newPageErrorIndicatorBuilder: (context) =>
                    const Center(child: Text('가져오기 실패')),
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1 / 1.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
            ),
          ),

          // 인물 북마크 탭바 뷰
          RefreshIndicator(
              onRefresh: () async {
                viewModel.personPagingController.refresh();
              },
              child: PagedGridView(
                pagingController: viewModel.personPagingController,
                padding: const EdgeInsets.all(8),
                builderDelegate: PagedChildBuilderDelegate<Person>(
                  itemBuilder: (context, person, index) {
                    return PersonDataCard(
                      url: person.profilePath == null
                          ? null
                          : kProfileUrl + person.profilePath!,
                      title: person.name,
                      titleColor: Colors.white,
                      onCardTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChangeNotifierProvider(
                              create: (context) => PersonDetailViewModel(
                                person.id,
                                context.read<GetPersonDetailUseCase>(),
                                context.read<GetCastWithPersonUseCase>(),
                                context.read<FindBookmarkDataUseCase<Person>>(),
                                context.read<SaveBookmarkDataUseCase<Person>>(),
                                context
                                    .read<DeleteBookmarkDataUseCase<Person>>(),
                              ),
                              child: const PersonDetailScreen(),
                            ),
                          ),
                        ).then(
                            (_) => viewModel.personPagingController.refresh());
                      },
                    );
                  },
                  noItemsFoundIndicatorBuilder: (context) => Column(
                    children: const [
                      Text('저장된 인물이 없습니다.'),
                    ],
                  ),
                  firstPageErrorIndicatorBuilder: (context) =>
                      const Center(child: Text('가져오기 실패')),
                  newPageErrorIndicatorBuilder: (context) =>
                      const Center(child: Text('가져오기 실패')),
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1 / 1.8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
              )),

          // 리뷰 탭바 뷰
          RefreshIndicator(
            onRefresh: () async {
              viewModel.reviewPagingController.refresh();
            },
            child: PagedListView(
              pagingController: viewModel.reviewPagingController,
              builderDelegate: PagedChildBuilderDelegate<Review>(
                itemBuilder: (context, review, index) {
                  return Slidable(
                    key: ValueKey(review.id),
                    endActionPane: ActionPane(
                      motion: ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (contenxt) {
                            viewModel.onEvent(
                                MovieBookmarkEvent.deleteReview(review));
                          },
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: '삭제',
                        ),
                      ],
                    ),
                    child: InkWell(
                      onTap: () async {
                        await Navigator.of(context)
                            .push(
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
                            )
                            .then((_) =>
                                viewModel.reviewPagingController.refresh());
                      },
                      child: Column(
                        children: [
                          Row(
                            children: [
                              review.posterPath == null
                                  ? Image.asset(
                                      'asset/image/poster_placeholder.png')
                                  : CachedNetworkImage(
                                      imageUrl: kPosterUrl + review.posterPath!,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                              Expanded(
                                  child: Column(
                                children: [
                                  // 타이틀
                                  Text(review.movieTitle),
                                  const SizedBox(height: 10),

                                  // 내용
                                  Text(
                                    review.content,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  const SizedBox(height: 10),

                                  // 별점
                                  RatingStars(
                                    starCount: 5,
                                    starSize: 30,
                                    starSpacing: 10,
                                    value: review.starRating,
                                    valueLabelVisibility: false,
                                  ),
                                ],
                              )),
                            ],
                          ),
                          const Divider(
                            height: 7,
                            color: whiteColor,
                            thickness: 0.5,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfileButton(BuildContext context) {
    final viewModel = context.read<AuthViewModel>();
    final photoUrl = viewModel.user.photoUrl;

    return IconButton(
      onPressed: () {
        Navigator.of(context)
            .push(
          MaterialPageRoute(
            builder: (context) => SettingScreen(),
          ),
        )
            .then((_) {
          context
              .read<MovieBookmarkViewModel>()
              .onEvent(MovieBookmarkEvent.load());
        });
      },
      icon: Container(
        width: 28,
        height: 28,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: photoUrl == ''
              ? Image.asset('asset/image/avatar_placeholder.png')
              : CachedNetworkImage(
                  imageUrl: photoUrl,
                  errorWidget: (context, _, __) =>
                      Image.asset('asset/image/avatar_placeholder.png'),
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}


// Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Row(
                //     children: [
                //       Spacer(),
                //       GestureDetector(
                //         onTap: () async {
                //           print(state.orderType.runtimeType
                //               .toString()
                //               .split('('));
                //           final dialog = AlertDialog(
                //             content: Column(
                //               mainAxisSize: MainAxisSize.min,
                //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //               crossAxisAlignment: CrossAxisAlignment.start,
                //               children: [
                //                 Text('정렬 순서'),
                //                 FittedBox(
                //                   child: Row(
                //                     children: [
                //                       Radio<String>(
                //                           value: 'OrderType.date',
                //                           groupValue: state
                //                               .orderType.runtimeType
                //                               .toString()
                //                               .split('(')[0],
                //                           onChanged: (value) {
                //                             if (value != null) {
                //                               viewModel.onEvent(
                //                                 MovieBookmarkEvent.orderChange(
                //                                   OrderType.date(true),
                //                                 ),
                //                               );
                //                             }
                //                           }),
                //                       Text('날짜순'),
                //                       Radio<String>(
                //                           value: 'OrderType.rating',
                //                           groupValue: state
                //                               .orderType.runtimeType
                //                               .toString()
                //                               .split('(')[0],
                //                           onChanged: (value) {
                //                             if (value != null) {
                //                               viewModel.onEvent(
                //                                 MovieBookmarkEvent.orderChange(
                //                                   OrderType.rating(true),
                //                                 ),
                //                               );
                //                             }
                //                           }),
                //                       Text('별점순'),
                //                       Radio<String>(
                //                           value: 'OrderType.title',
                //                           groupValue: state
                //                               .orderType.runtimeType
                //                               .toString()
                //                               .split('(')[0],
                //                           onChanged: (value) {
                //                             if (value != null) {
                //                               viewModel.onEvent(
                //                                 MovieBookmarkEvent.orderChange(
                //                                   OrderType.title(true),
                //                                 ),
                //                               );
                //                             }
                //                           }),
                //                       Text('제목순'),
                //                     ],
                //                   ),
                //                 ),
                //                 Divider(
                //                   height: 0,
                //                   color: whiteColor,
                //                 ),
                //               ],
                //             ),
                //             contentPadding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                //             buttonPadding: EdgeInsets.zero,
                //             actionsPadding: EdgeInsets.zero,
                //             actions: [
                //               SizedBox(
                //                 width: double.infinity,
                //                 child: TextButton(
                //                     onPressed: () {},
                //                     child: Text(
                //                       '확인',
                //                       style: TextStyle(color: whiteColor),
                //                     )),
                //               )
                //             ],
                //           );
                //           final result = await showDialog(
                //               context: context, builder: (_) => dialog);
                //         },
                //         child: Row(
                //           children: [Text('정렬'), Icon(Icons.sort)],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // Divider(height: 2, thickness: 0.5, color: whiteColor),
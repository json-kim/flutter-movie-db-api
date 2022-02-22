import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/model/person/person.dart';
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
import 'package:movie_search/ui/navigator_key.dart';
import 'package:movie_search/ui/theme.dart';
import 'package:provider/provider.dart';

class MovieBookmarkScreen extends StatefulWidget {
  const MovieBookmarkScreen({Key? key}) : super(key: key);

  @override
  State<MovieBookmarkScreen> createState() => _MovieBookmarkScreenState();
}

class _MovieBookmarkScreenState extends State<MovieBookmarkScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      context
          .read<MovieBookmarkViewModel>()
          .onEvent(const MovieBookmarkEvent.load());
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MovieBookmarkViewModel>();
    final state = viewModel.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('마이 노트'),
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
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          // 영화 북마크 탭바뷰
          RefreshIndicator(
            onRefresh: () async {},
            child: GridView.builder(
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
                                    context.read<
                                        DeleteBookmarkDataUseCase<Movie>>(),
                                    context.read<GetReviewByMovieUseCase>(),
                                    context.read<DeleteReviewUseCase>(),
                                    movieId: movie.id),
                                child: const MovieDetailScreen(),
                              ),
                            ),
                          )
                          .then((_) => viewModel
                              .onEvent(const MovieBookmarkEvent.load()));
                    });
              },
            ),
          ),

          // 인물 북마크 탭바 뷰
          RefreshIndicator(
            onRefresh: () async {},
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1 / 1.8,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: state.bookmarkPerson.length,
              itemBuilder: (context, idx) {
                final person = state.bookmarkPerson[idx];
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
                            context.read<DeleteBookmarkDataUseCase<Person>>(),
                          ),
                          child: const PersonDetailScreen(),
                        ),
                      ),
                    ).then((_) =>
                        viewModel.onEvent(const MovieBookmarkEvent.load()));
                  },
                );
              },
            ),
          ),

          // 리뷰 탭바 뷰
          RefreshIndicator(
            onRefresh: () async {},
            child: ListView.builder(
              itemCount: state.reviews.length,
              itemBuilder: (context, idx) {
                final review = state.reviews[idx];

                return InkWell(
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
                            viewModel.onEvent(const MovieBookmarkEvent.load()));
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

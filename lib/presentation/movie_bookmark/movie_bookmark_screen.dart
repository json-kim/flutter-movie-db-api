import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/usecase/bookmark/delete_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/find_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/save_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/cast/get_cast_with_person_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_detail_use_case.dart';
import 'package:movie_search/domain/usecase/person/get_person_detail_use_case.dart';
import 'package:movie_search/presentation/global_components/movie_data_card.dart';
import 'package:movie_search/presentation/movie_bookmark/movie_bookmark_event.dart';
import 'package:movie_search/presentation/movie_bookmark/movie_bookmark_view_model.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_screen.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_view_model.dart';
import 'package:movie_search/presentation/person_detail/person_detail_screen.dart';
import 'package:movie_search/presentation/person_detail/person_detail_view_model.dart';
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
        title: const Text('북마크'),
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
          GridView.builder(
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
                                  context
                                      .read<FindBookmarkDataUseCase<Movie>>(),
                                  context
                                      .read<SaveBookmarkDataUseCase<Movie>>(),
                                  context
                                      .read<DeleteBookmarkDataUseCase<Movie>>(),
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

          // 인물 북마크 탭바 뷰
          GridView.builder(
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
              return InkWell(
                onTap: () {
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
                  );
                },
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      Flexible(
                        flex: 8,
                        fit: FlexFit.tight,
                        child: person.profilePath == null
                            ? Image.asset(
                                'asset/image/poster_placeholder.png',
                              )
                            : CachedNetworkImage(
                                imageUrl: kProfileUrl + person.profilePath!,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                fit: BoxFit.cover,
                              ),
                      ),
                      Flexible(
                        flex: 2,
                        fit: FlexFit.tight,
                        child: Center(
                          child: Text(
                            person.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),

          // 리뷰 탭바 뷰
          Container(),
        ],
      ),
    );
  }
}

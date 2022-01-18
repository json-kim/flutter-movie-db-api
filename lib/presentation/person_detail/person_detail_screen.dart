import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_detail_use_case.dart';
import 'package:movie_search/presentation/global_components/movie_data_card.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_screen.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_view_model.dart';
import 'package:movie_search/ui/theme.dart';
import 'package:provider/provider.dart';

import 'person_detail_view_model.dart';

class PersonDetailScreen extends StatelessWidget {
  const PersonDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PersonDetailViewModel>();
    final state = viewModel.state;

    return state.isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: whiteColor,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.bookmark_outline))
              ],
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      state.person?.profilePath == null
                          ? Container(
                              color: Colors.black,
                            )
                          : CachedNetworkImage(
                              imageUrl:
                                  kLargeProfileUrl + state.person!.profilePath!,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                      Container(
                        color: Colors.black.withOpacity(0.3),
                      ),
                      Positioned(
                          bottom: 16,
                          left: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.person!.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4!
                                    .copyWith(color: Colors.white),
                              ),
                              Text(
                                state.person!.knownForDepartment,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '생년월일',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(color: Colors.black),
                                      ),
                                      Text(
                                        state.person?.birthday ?? '불명',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '출생지',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6!
                                            .copyWith(color: Colors.black),
                                      ),
                                      Text(
                                        state.person?.placeOfBirth ?? '불명',
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Text(
                              '관련 작품',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(color: Colors.black),
                            ),
                          ),
                        ),
                        SliverGrid(
                          delegate: SliverChildListDelegate(
                            state.casts
                                .map(
                                  (cast) => MovieDataCard(
                                    url: cast.posterPath == null
                                        ? null
                                        : kPosterUrl + cast.posterPath!,
                                    title: cast.title,
                                    onCardTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ChangeNotifierProvider(
                                            create: (context) =>
                                                MovieDetailViewModel(
                                                    context.read<
                                                        GetMovieDetailUseCase>(),
                                                    movieId: cast.id),
                                            child: const MovieDetailScreen(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                                .toList(),
                          ),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                  childAspectRatio: 1 / 1.8),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}

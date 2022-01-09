import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movie_search/config/theme.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/entity/credit/credit.dart';
import 'package:movie_search/domain/entity/movie/movie.dart';
import 'package:movie_search/domain/entity/video/video.dart';
import 'package:movie_search/domain/usecase/get_credit_with_movie_use_case.dart';
import 'package:movie_search/domain/usecase/get_movie_similar_use_case.dart';
import 'package:movie_search/domain/usecase/get_video_with_movie_use_case.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_view_model.dart';
import 'package:movie_search/presentation/movie_list/data_list_view_model.dart';
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
  bool screenState = false;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MovieDetailViewModel>();
    final state = viewModel.state;
    final size = MediaQuery.of(context).size;

    return state.map(
      empty: (_) => const Center(child: CircularProgressIndicator()),
      state: (state) => Scaffold(
        backgroundColor: kWhiteColor,
        extendBodyBehindAppBar: true,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              actions: [
                IconButton(
                  icon: const Icon(Icons.bookmark_outline),
                  onPressed: () {
                    // 북마크 체크시 저장 하는 기능 추가
                  },
                )
              ],
              collapsedHeight: 150,
              pinned: true,
              expandedHeight: size.height,
              elevation: 0,
              flexibleSpace: Stack(
                clipBehavior: Clip.none,
                children: [
                  CachedNetworkImage(
                    imageUrl: kBackdropUrl + state.movieDetail.backdropPath!,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
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
                        if (constraints.maxHeight < size.height * 0.65) {
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
                                  state.movieDetail.title,
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '개봉일: ${state.movieDetail.releaseDate}'),
                                        Row(
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {},
                                                child: Row(
                                                  children: [
                                                    const Icon(Icons.check),
                                                    Text(state
                                                        .movieDetail.voteCount
                                                        .toString()),
                                                  ],
                                                )),
                                            const SizedBox(width: 8),
                                            ElevatedButton(
                                              onPressed: () {},
                                              child: Row(
                                                children: [
                                                  const Icon(Icons.star),
                                                  Text(
                                                    state
                                                        .movieDetail.voteAverage
                                                        .toString(),
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
                                state.movieDetail.overview ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                                maxLines: 10,
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
                          color: kWhiteColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              topLeft: Radius.circular(16))),
                    ),
                  )
                ],
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverFixedHeader(
                minHeight: 100,
                maxHeight: 100,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  color: kWhiteColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Text(state.movieDetail.title,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 24)),
                            ),
                            FittedBox(
                              child: Text(state.movieDetail.originalTitle,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 16)),
                            ),
                            Expanded(child: Container()),
                            Row(
                              children: state.movieDetail.genres
                                  .take(3)
                                  .map(
                                    (e) => Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text('#' + e.name,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 14)),
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
                            Text(state.movieDetail.voteAverage.toString()),
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
            ),
            // 배우 제작진
            ChangeNotifierProvider(
                create: (context) => DataListViewModel<Credit, Movie>(
                    context.read<GetCreditWithMovieUseCase>(), viewModel.movie),
                child: const CreditSliverList()),
            //TODO: 관련 영상
            ChangeNotifierProvider(
                create: (context) => DataListViewModel<Video, Movie>(
                    context.read<GetVideoWithMovieUseCase>(), viewModel.movie),
                child: const VideoSliverList()),
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
                create: (context) => DataListViewModel<Movie, Movie>(
                    context.read<GetMovieSimilarUseCase>(), viewModel.movie),
                child: const SimilarSliverGrid()),
          ],
        ),
      ),
    );
  }
}

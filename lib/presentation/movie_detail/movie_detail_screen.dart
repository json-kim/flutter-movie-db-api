import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:movie_search/config/theme.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_view_model.dart';
import 'package:provider/provider.dart';

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
              collapsedHeight: 150,
              pinned: true,
              expandedHeight: size.height,
              elevation: 0,
              flexibleSpace: Stack(
                clipBehavior: Clip.none,
                children: [
                  Image.network(
                    kBackdropUrl + state.movieDetail.backdropPath!,
                    height: size.height,
                    width: size.width,
                    fit: BoxFit.cover,
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
                              Text(
                                state.movieDetail.title,
                                style: const TextStyle(
                                  fontSize: 36,
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
            //TODO: 배우 제작진
            SliverPersistentHeader(
                floating: true,
                delegate: SliverFixedHeader(
                  maxHeight: 250,
                  minHeight: 250,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    color: kWhiteColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Text(
                            '배우 / 제작진',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.credits.length,
                            itemBuilder: (context, idx) => Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: AspectRatio(
                                aspectRatio: 0.8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child:
                                          state.credits[idx].profilePath == null
                                              ? const Center(
                                                  child: Text(
                                                    'No Image',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                )
                                              : Image.network(
                                                  kProfileUrl +
                                                      state.credits[idx]
                                                          .profilePath!,
                                                  width: double.infinity,
                                                  fit: BoxFit.cover,
                                                ),
                                    ),
                                    FittedBox(
                                      child: Text(
                                        state.credits[idx].name,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                    FittedBox(
                                      child: Text(
                                        state.credits[idx].character,
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            //TODO: 관련 영상
            SliverPersistentHeader(
                // floating: true,
                delegate: SliverFixedHeader(
              maxHeight: 250,
              minHeight: 250,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: kWhiteColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text(
                        '관련 동영상',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, idx) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AspectRatio(
                                aspectRatio: 1.6,
                                child: Image.network(
                                  'https://st2.depositphotos.com/1463799/8551/v/950/depositphotos_85514382-stock-illustration-winter-adventure-travel-vacation-poster.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Text(
                              '안소니 루소',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                        itemCount: 10,
                      ),
                    ),
                  ],
                ),
              ),
            )),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '비슷한 작품',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
              ),
            ),
            SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Image.network(
                    'https://st2.depositphotos.com/1463799/8551/v/950/depositphotos_85514382-stock-illustration-winter-adventure-travel-vacation-poster.jpg',
                    fit: BoxFit.cover,
                  ),
                  childCount: 10,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 1 / 1.3))
          ],
        ),
      ),
    );
  }
}

class SliverFixedHeader extends SliverPersistentHeaderDelegate {
  final double maxHeight;
  final double minHeight;
  final Widget child;

  SliverFixedHeader(
      {required this.maxHeight, required this.minHeight, required this.child});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: child,
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverFixedHeader oldDelegate) {
    return oldDelegate.minHeight != maxHeight ||
        oldDelegate.minHeight != minHeight ||
        oldDelegate.child != child;
  }
}

import 'package:flutter/material.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:provider/provider.dart';

import 'movie_home_view_model.dart';

class MovieHomeScreen extends StatelessWidget {
  const MovieHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<MovieHomeViewModel>();
    return Scaffold(
      body: _buildBody(viewModel),
    );
  }

  Widget _buildBody(MovieHomeViewModel viewModel) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            height: 300,
            child: PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.nowPlayingMovies.length,
              itemBuilder: (context, idx) {
                final movie = viewModel.nowPlayingMovies[idx];
                return Stack(
                  children: [
                    SizedBox.expand(
                      child: Image.network(
                        kBackdropUrl + movie.backdropPath,
                        // movie.posterUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.6),
                            offset: const Offset(0, 300),
                            blurRadius: 50,
                            spreadRadius: 50,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(movie.title,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                          Text(movie.originalTitle),
                          const SizedBox(height: 8),
                          Text(
                            movie.overview,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 16,
                      child: Container(
                          color: Colors.pink,
                          child: Text('평점: ${movie.voteAverage}')),
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

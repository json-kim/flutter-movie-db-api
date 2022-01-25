import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/presentation/movie_bookmark/movie_bookmark_view_model.dart';
import 'package:provider/provider.dart';

class MovieBookmarkScreen extends StatefulWidget {
  const MovieBookmarkScreen({Key? key}) : super(key: key);

  @override
  State<MovieBookmarkScreen> createState() => _MovieBookmarkScreenState();
}

class _MovieBookmarkScreenState extends State<MovieBookmarkScreen> {
  @override
  void initState() {
    Future.microtask(() {
      context.read<MovieBookmarkViewModel>().loadBookmarkMovie();
    });
    super.initState();
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
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1 / 1.8,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: state.bookmarkMovies.length,
        itemBuilder: (context, idx) {
          return CachedNetworkImage(
              imageUrl: kPosterUrl + state.bookmarkMovies[idx].posterPath!);
        },
      ),
    );
  }
}

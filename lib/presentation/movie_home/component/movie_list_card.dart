import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/model/movie/movie.dart';

class MovieListCard extends StatelessWidget {
  const MovieListCard({
    Key? key,
    required this.movie,
    required this.onCardTap,
  }) : super(key: key);

  final Movie movie;
  final void Function()? onCardTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: SizedBox(
        width: 115,
        child: Column(
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: kPosterUrl + movie.posterPath!,
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  movie.title,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

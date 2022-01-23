import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/model/movie/movie.dart';

class MoviePageCard extends StatelessWidget {
  const MoviePageCard({
    Key? key,
    required this.movie,
    required this.onTap,
  }) : super(key: key);

  final void Function() onTap;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 1,
            left: 0,
            right: 0,
            top: 0,
            child: SizedBox.expand(
              child: CachedNetworkImage(
                imageUrl: kBackdropUrl + movie.backdropPath!,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, 350),
                  blurRadius: 50,
                  spreadRadius: 50,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 50,
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
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Positioned(
            top: 50,
            right: 16,
            child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.pink,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('평점: ${movie.voteAverage}')),
          )
        ],
      ),
    );
  }
}

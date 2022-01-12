import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/model/movie/movie.dart';

class MovieGridViewCard extends StatelessWidget {
  const MovieGridViewCard({
    Key? key,
    required this.onCardTap,
    required this.movie,
  }) : super(key: key);

  final void Function()? onCardTap;
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCardTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 8,
            fit: FlexFit.tight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: movie.posterPath == null
                  ? Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'no image',
                      ),
                    )
                  : CachedNetworkImage(
                      imageUrl: kPosterUrl + movie.posterPath!,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Center(
              child: Text(
                movie.title,
                style:
                    const TextStyle(fontSize: 16, overflow: TextOverflow.fade),
              ),
            ),
          )
        ],
      ),
    );
  }
}

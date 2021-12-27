import 'package:flutter/material.dart';
import 'package:movie_search/model/movie.dart';
import 'package:movie_search/ui/movie_detail/movie_detail_screen.dart';

class MovieGridViewCard extends StatelessWidget {
  const MovieGridViewCard({
    Key? key,
    required this.movie,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(
              movie: movie,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            flex: 8,
            fit: FlexFit.tight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: movie.posterPath.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'no image',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : Image.network(
                      movie.posterUrl,
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
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    overflow: TextOverflow.fade),
              ),
            ),
          )
        ],
      ),
    );
  }
}

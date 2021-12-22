import 'package:flutter/material.dart';
import 'package:movie_search/model/movie.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            movie.title,
            style: const TextStyle(fontSize: 36, color: Colors.blue),
          ),
          SizedBox(
            height: 300,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: movie.posterPath.isEmpty
                      ? Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          child: const Text(
                            'no image',
                          ),
                        )
                      : Image.network(
                          movie.posterUrl,
                          fit: BoxFit.cover,
                        ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('개봉일: ${movie.releaseDate}'),
                      Row(
                        children: [
                          ElevatedButton(
                              onPressed: () {},
                              child: Row(
                                children: [
                                  const Icon(Icons.check),
                                  Text(movie.voteCount.toString()),
                                ],
                              )),
                          ElevatedButton(
                            onPressed: () {},
                            child: Row(
                              children: [
                                const Icon(Icons.star),
                                Text(
                                  movie.voteAverage.toString(),
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
          ),
          Text(
            movie.overview,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

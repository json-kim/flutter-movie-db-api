import 'package:flutter/material.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/domain/entity/movie/movie.dart';
import 'package:movie_search/domain/usecase/get_movie_detail_use_case.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_screen.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_view_model.dart';
import 'package:provider/provider.dart';

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
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                    create: (context) => MovieDetailViewModel(
                      context.read<GetMovieDetailUseCase>(),
                      movie: movie,
                    ),
                    child: const MovieDetailScreen(),
                  )),
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
                  : Image.network(
                      kPosterUrl + movie.posterPath!,
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

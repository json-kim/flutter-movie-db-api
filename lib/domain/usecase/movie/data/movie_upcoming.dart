import 'package:movie_search/domain/model/movie/movie.dart';

class MovieUpcomingData {
  final Movie movie;
  final bool isAlarmed;

  MovieUpcomingData({
    required this.movie,
    required this.isAlarmed,
  });

  factory MovieUpcomingData.fromMovie(Movie movie, bool isAlarmed) {
    return MovieUpcomingData(movie: movie, isAlarmed: isAlarmed);
  }

  MovieUpcomingData copyWith({Movie? movie, bool? isAlarmed}) {
    return MovieUpcomingData(
      movie: movie ?? this.movie,
      isAlarmed: isAlarmed ?? this.isAlarmed,
    );
  }
}

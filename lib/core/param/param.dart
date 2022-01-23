import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_search/core/util/constants.dart';

part 'param.freezed.dart';

@freezed
class Param with _$Param {
  const factory Param.genres() = Genres;

  const factory Param.movieWithGenre(int genreId, {@Default(1) int page}) =
      MovieWithGenre;

  const factory Param.movieWithKeyword(int keyword, {@Default(1) int page}) =
      MovieWithKeyword;

  const factory Param.movieWithQuery(String query, {@Default(1) int page}) =
      MovieWithQuery;

  const factory Param.moviePopular({@Default(1) int page}) = MoviePopular;

  const factory Param.movieNowPlaying({@Default(1) int page}) = MovieNowPlaying;

  const factory Param.keywordWithMovie(int movieId) = KeywordWithMovie;

  const factory Param.reviewWithMovie(int movieId, {@Default(1) int page}) =
      ReviewWithMovie;

  const factory Param.videoWithMovie(int movieId) = VideoWithMovie;

  const factory Param.creditWithMovie(int movieId) = CreditWithMovie;

  const factory Param.movieSimilar(int movieId, {@Default(1) int page}) =
      MovieSimilar;

  const factory Param.movieRecommend(int movieId, {@Default(1) int page}) =
      MovieRecommend;

  const factory Param.movieDetail(int movieId) = MovieDetailParam;

  const factory Param.personDetail(int personId) = PersonDetail;

  const factory Param.castWithPerson(int personId) = CastWithPerson;
}

String paramToUrl(Param param, String language) {
  return param.when<String>(
    genres: () =>
        '${kBaseUrl}genre/movie/list?api_key=$kApiKey&language=$language',
    movieWithGenre: (int genreId, int page) =>
        '${kBaseUrl}discover/movie?api_key=$kApiKey&language=$language&page=$page&with_genres=$genreId',
    movieWithKeyword: (int keywordId, int page) =>
        '${kBaseUrl}keyword/$keywordId/movie?api_key=$kApiKey&language=$language&page=$page',
    movieWithQuery: (String query, int page) =>
        '${kBaseUrl}search/movie?api_key=$kApiKey&language=$language&page=$page&query=${queryChange(query)}',
    moviePopular: (int page) =>
        '${kBaseUrl}movie/popular?api_key=$kApiKey&language=$language&page=$page',
    movieNowPlaying: (int page) =>
        '${kBaseUrl}movie/now_playing?api_key=$kApiKey&language=$language&page=$page',
    keywordWithMovie: (int movieId) =>
        '${kBaseUrl}movie/$movieId/keywords?api_key=$kApiKey&language=$language',
    reviewWithMovie: (int movieId, int page) =>
        '${kBaseUrl}movie/$movieId/reviews?api_key=$kApiKey&language=$language&page=$page',
    videoWithMovie: (int movieId) =>
        '${kBaseUrl}movie/$movieId/videos?api_key=$kApiKey&language=$language',
    creditWithMovie: (int movieId) =>
        '${kBaseUrl}movie/$movieId/credits?api_key=$kApiKey&language=$language',
    movieSimilar: (int movieId, int page) =>
        '${kBaseUrl}movie/$movieId/similar?api_key=$kApiKey&language=$language&page=$page',
    movieRecommend: (int movieId, int page) =>
        '${kBaseUrl}movie/$movieId/recommendations?api_key=$kApiKey&language=$language&page=$page',
    movieDetail: (int movieId) =>
        '${kBaseUrl}movie/$movieId?api_key=$kApiKey&language=$language',
    personDetail: (int personId) =>
        '${kBaseUrl}person/$personId?api_key=$kApiKey&language=$language',
    castWithPerson: (int personId) =>
        '${kBaseUrl}person/$personId/movie_credits?api_key=$kApiKey&language=$language',
  );
}

String queryChange(String query) {
  return (query.split(' ')..removeWhere((e) => e.trim().isEmpty)).join('+');
}

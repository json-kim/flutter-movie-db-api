// 1. Provider 전체
import 'package:movie_search/data/data_source/tmdb_api.dart';
import 'package:movie_search/data/repository/api_genre_data_repository.dart';
import 'package:movie_search/data/repository/api_movie_data_repository.dart';
import 'package:movie_search/domain/usecase/get_genre_use_case.dart';
import 'package:movie_search/domain/usecase/get_movie_now_playing_use_case.dart';
import 'package:movie_search/domain/usecase/get_movie_popular_use_case.dart';
import 'package:movie_search/domain/usecase/get_movie_with_genre_use_case.dart';
import 'package:movie_search/presentation/movie_home/movie_home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> globalProviders = [
  ...independentModels,
  ...dependentModels,
  ...viewModels,
];

// 2. 독립적인 객체
List<SingleChildWidget> independentModels = [
  Provider<TMDBApi>(
    create: (context) => TMDBApi(),
  ),
];

// 3. 2번에 의존성있는 객체
List<SingleChildWidget> dependentModels = [
  ProxyProvider<TMDBApi, ApiMovieDataRepository>(
    update: (context, tmdbApi, _) => ApiMovieDataRepository(tmdbApi),
  ),
  ProxyProvider<TMDBApi, ApiGenreDataRepository>(
    update: (context, tmdbApi, _) => ApiGenreDataRepository(tmdbApi),
  ),
  ProxyProvider<ApiMovieDataRepository, GetMoviePopularUseCase>(
    update: (context, repository, _) => GetMoviePopularUseCase(repository),
  ),
  ProxyProvider<ApiMovieDataRepository, GetMovieNowPlayingUseCase>(
    update: (context, repository, _) => GetMovieNowPlayingUseCase(repository),
  ),
  ProxyProvider<ApiMovieDataRepository, GetMovieWithGenreUseCase>(
    update: (context, repository, _) => GetMovieWithGenreUseCase(repository),
  ),
  ProxyProvider<ApiGenreDataRepository, GetGenreUseCase>(
    update: (context, repository, _) => GetGenreUseCase(repository),
  ),
];

// 4. ViewModels
List<SingleChildWidget> viewModels = [
  ChangeNotifierProvider(
    create: (context) => MovieHomeViewModel(
      context.read<GetMoviePopularUseCase>(),
      context.read<GetMovieNowPlayingUseCase>(),
      context.read<GetMovieWithGenreUseCase>(),
      context.read<GetGenreUseCase>(),
    ),
  ),
];

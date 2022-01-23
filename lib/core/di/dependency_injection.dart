// 1. Provider 전체
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/data/repository/movie_data/cast_data_repository_impl.dart';
import 'package:movie_search/data/repository/movie_data/credit_data_repository_impl.dart';
import 'package:movie_search/data/repository/movie_data/genre_data_repository_impl.dart';
import 'package:movie_search/data/repository/movie_data/movie_data_repository_impl.dart';
import 'package:movie_search/data/repository/movie_data/movie_detail_data_repository_impl.dart';
import 'package:movie_search/data/repository/movie_data/person_data_repository_impl.dart';
import 'package:movie_search/data/repository/movie_data/video_data_repository_impl.dart';
import 'package:movie_search/domain/usecase/cast/get_cast_with_person_use_case.dart';
import 'package:movie_search/domain/usecase/credit/get_credit_with_movie_use_case.dart';
import 'package:movie_search/domain/usecase/genre/get_genre_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_detail_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_now_playing_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_popular_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_similar_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_with_genre_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_with_query_use_case.dart';
import 'package:movie_search/domain/usecase/person/get_person_detail_use_case.dart';
import 'package:movie_search/domain/usecase/video/get_video_with_movie_use_case.dart';
import 'package:movie_search/presentation/movie_home/movie_home_view_model.dart';
import 'package:movie_search/presentation/movie_search/movie_search_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> globalProviders = [
  ...independentModels,
  ...dependentModels,
  ...viewModels,
];

// 2. 독립적인 객체
List<SingleChildWidget> independentModels = [
  Provider<MovieRemoteDataSource>(
    create: (context) => MovieRemoteDataSource(),
  ),
];

// 3. 2번에 의존성있는 객체
List<SingleChildWidget> dependentModels = [
  // Repository
  ProxyProvider<MovieRemoteDataSource, MovieDataRepositoryImpl>(
    update: (context, tmdbApi, _) => MovieDataRepositoryImpl(tmdbApi),
  ),
  ProxyProvider<MovieRemoteDataSource, GenreDataRepositoryImpl>(
    update: (context, tmdbApi, _) => GenreDataRepositoryImpl(tmdbApi),
  ),
  ProxyProvider<MovieRemoteDataSource, MovieDetailDataRepositoryImpl>(
    update: (context, tmdbApi, _) => MovieDetailDataRepositoryImpl(tmdbApi),
  ),
  ProxyProvider<MovieRemoteDataSource, CreditDataRepositoryImpl>(
    update: (context, tmdbApi, _) => CreditDataRepositoryImpl(tmdbApi),
  ),
  ProxyProvider<MovieRemoteDataSource, VideoDataRepositoryImpl>(
    update: (context, tmdbApi, _) => VideoDataRepositoryImpl(tmdbApi),
  ),
  ProxyProvider<MovieRemoteDataSource, PersonDataRepositoryImpl>(
    update: (context, tmdbApi, _) => PersonDataRepositoryImpl(tmdbApi),
  ),
  ProxyProvider<MovieRemoteDataSource, CastDataRepositoryImpl>(
    update: (context, tmdbApi, _) => CastDataRepositoryImpl(tmdbApi),
  ),

  // UseCase
  ProxyProvider<PersonDataRepositoryImpl, GetPersonDetailUseCase>(
    update: (context, repository, _) => GetPersonDetailUseCase(repository),
  ),
  ProxyProvider<CastDataRepositoryImpl, GetCastWithPersonUseCase>(
    update: (context, repository, _) => GetCastWithPersonUseCase(repository),
  ),
  ProxyProvider<VideoDataRepositoryImpl, GetVideoWithMovieUseCase>(
    update: (context, repository, _) => GetVideoWithMovieUseCase(repository),
  ),
  ProxyProvider<CreditDataRepositoryImpl, GetCreditWithMovieUseCase>(
    update: (context, repository, _) => GetCreditWithMovieUseCase(repository),
  ),
  ProxyProvider<MovieDataRepositoryImpl, GetMoviePopularUseCase>(
    update: (context, repository, _) => GetMoviePopularUseCase(repository),
  ),
  ProxyProvider<MovieDataRepositoryImpl, GetMovieWithQueryUseCase>(
    update: (context, repository, _) => GetMovieWithQueryUseCase(repository),
  ),
  ProxyProvider<MovieDataRepositoryImpl, GetMovieNowPlayingUseCase>(
    update: (context, repository, _) => GetMovieNowPlayingUseCase(repository),
  ),
  ProxyProvider<MovieDataRepositoryImpl, GetMovieWithGenreUseCase>(
    update: (context, repository, _) => GetMovieWithGenreUseCase(repository),
  ),
  ProxyProvider<MovieDataRepositoryImpl, GetMovieSimilarUseCase>(
    update: (context, repository, _) => GetMovieSimilarUseCase(repository),
  ),
  ProxyProvider<GenreDataRepositoryImpl, GetGenreUseCase>(
    update: (context, repository, _) => GetGenreUseCase(repository),
  ),
  ProxyProvider<MovieDetailDataRepositoryImpl, GetMovieDetailUseCase>(
    update: (context, repository, _) => GetMovieDetailUseCase(repository),
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
  ChangeNotifierProvider(
    create: (context) => MovieSearchViewModel(
      context.read<GetMovieWithQueryUseCase>(),
    ),
  )
];

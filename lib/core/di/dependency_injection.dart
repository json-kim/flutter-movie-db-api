// 1. Provider 전체
import 'package:movie_search/data/data_source/local/movie_local_data_source.dart';
import 'package:movie_search/data/data_source/local/person_local_data_source.dart';
import 'package:movie_search/data/data_source/local/review_local_data_source.dart';
import 'package:movie_search/data/data_source/local/search_history_local_data_source.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/data/repository/bookmark_data/bookmark_movie_repository_impl.dart';
import 'package:movie_search/data/repository/bookmark_data/bookmark_person_repository_impl.dart';
import 'package:movie_search/data/repository/movie_data/cast_data_repository_impl.dart';
import 'package:movie_search/data/repository/movie_data/credit_data_repository_impl.dart';
import 'package:movie_search/data/repository/movie_data/genre_data_repository_impl.dart';
import 'package:movie_search/data/repository/movie_data/movie_data_repository_impl.dart';
import 'package:movie_search/data/repository/movie_data/movie_detail_data_repository_impl.dart';
import 'package:movie_search/data/repository/movie_data/person_data_repository_impl.dart';
import 'package:movie_search/data/repository/movie_data/video_data_repository_impl.dart';
import 'package:movie_search/data/repository/review/review_data_repository_impl.dart';
import 'package:movie_search/data/repository/search_history/search_history_repository_impl.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/model/person/person.dart';
import 'package:movie_search/domain/repository/review_data_repository.dart';
import 'package:movie_search/domain/repository/search_history_repository.dart';
import 'package:movie_search/domain/usecase/bookmark/delete_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/find_bookmark_data_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/get_bookmark_datas_use_case.dart';
import 'package:movie_search/domain/usecase/bookmark/save_bookmark_data_use_case.dart';
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
import 'package:movie_search/domain/usecase/review/create_review_use_case.dart';
import 'package:movie_search/domain/usecase/review/delete_review_use_case.dart';
import 'package:movie_search/domain/usecase/review/get_review_by_movie_use_case.dart';
import 'package:movie_search/domain/usecase/review/get_reviews_use_case.dart';
import 'package:movie_search/domain/usecase/review/update_review_use_case.dart';
import 'package:movie_search/domain/usecase/search_history/delete_all_histories_use_case.dart';
import 'package:movie_search/domain/usecase/search_history/delete_search_history_use_case.dart';
import 'package:movie_search/domain/usecase/search_history/get_search_histories_use_case.dart';
import 'package:movie_search/domain/usecase/search_history/save_search_history_use_case.dart';
import 'package:movie_search/domain/usecase/search_history/search_history_use_cases.dart';
import 'package:movie_search/domain/usecase/video/get_video_with_movie_use_case.dart';
import 'package:movie_search/presentation/auth/auth_view_model.dart';
import 'package:movie_search/presentation/movie_bookmark/movie_bookmark_view_model.dart';
import 'package:movie_search/presentation/movie_home/movie_home_view_model.dart';
import 'package:movie_search/presentation/movie_search/movie_search_view_model.dart';
import 'package:movie_search/service/hive_service.dart';
import 'package:movie_search/service/sql_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<List<SingleChildWidget>> setProvider() async {
  await SqlService.instance.init();
  final db = SqlService.instance.db;

  await HiveService.instance.init();
  final box = HiveService.instance.searchBox;

  List<SingleChildWidget> providers = [
    // 데이터 소스
    Provider<MovieRemoteDataSource>(
      create: (context) => MovieRemoteDataSource(),
    ),
    Provider<MovieLocalDataSource>(
      create: (context) => MovieLocalDataSource(db!),
    ),
    Provider<PersonLocalDataSource>(
      create: (context) => PersonLocalDataSource(db!),
    ),
    Provider<ReviewLocalDataSource>(
      create: (context) => ReviewLocalDataSource(db!),
    ),
    Provider<SearchHistoryLocalDataSource>(
      create: (context) => SearchHistoryLocalDataSource(box!),
    ),

    // 레포지토리
    ProxyProvider<SearchHistoryLocalDataSource, SearchHistoryRepository>(
      update: (context, dataSource, _) =>
          SearchHistoryRepositoryImpl(dataSource),
    ),
    ProxyProvider<ReviewLocalDataSource, ReviewDataRepository>(
      update: (context, dataSource, _) => ReviewDataRepositoryImple(dataSource),
    ),
    ProxyProvider<MovieLocalDataSource, BookmarkMovieRepositoryImpl>(
      update: (context, dataSource, _) =>
          BookmarkMovieRepositoryImpl(dataSource),
    ),
    ProxyProvider<PersonLocalDataSource, BookmarkPersonRepositoryImpl>(
      update: (context, dataSource, _) =>
          BookmarkPersonRepositoryImpl(dataSource),
    ),
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

    // 유스케이스
    // 검색 기록 유스케이스
    ProxyProvider<SearchHistoryRepository, GetSearchHistoriesUseCase>(
      update: (context, repository, _) => GetSearchHistoriesUseCase(repository),
    ),
    ProxyProvider<SearchHistoryRepository, DeleteSearchHistoryUseCase>(
      update: (context, repository, _) =>
          DeleteSearchHistoryUseCase(repository),
    ),
    ProxyProvider<SearchHistoryRepository, DeleteAllHistoryUseCase>(
      update: (context, repository, _) => DeleteAllHistoryUseCase(repository),
    ),
    ProxyProvider<SearchHistoryRepository, SaveSearchHistoryUseCase>(
      update: (context, repository, _) => SaveSearchHistoryUseCase(repository),
    ),
    // 리뷰 유스케이스
    ProxyProvider<ReviewDataRepository, GetReviewByMovieUseCase>(
      update: (context, repository, _) => GetReviewByMovieUseCase(repository),
    ),
    ProxyProvider<ReviewDataRepository, GetReviewsUseCase>(
      update: (context, repository, _) => GetReviewsUseCase(repository),
    ),
    ProxyProvider<ReviewDataRepository, CreateReviewUseCase>(
      update: (context, repository, _) => CreateReviewUseCase(repository),
    ),
    ProxyProvider<ReviewDataRepository, DeleteReviewUseCase>(
      update: (context, repository, _) => DeleteReviewUseCase(repository),
    ),
    ProxyProvider<ReviewDataRepository, UpdateReviewUseCase>(
      update: (context, repository, _) => UpdateReviewUseCase(repository),
    ),
    ProxyProvider<ReviewDataRepository, CreateReviewUseCase>(
      update: (context, repository, _) => CreateReviewUseCase(repository),
    ),

    // 북마크<영화> 유스케이스
    ProxyProvider<BookmarkMovieRepositoryImpl, GetBookmarkDatasUseCase<Movie>>(
      update: (context, repository, _) =>
          GetBookmarkDatasUseCase<Movie>(repository),
    ),
    ProxyProvider<BookmarkMovieRepositoryImpl, FindBookmarkDataUseCase<Movie>>(
      update: (context, repository, _) =>
          FindBookmarkDataUseCase<Movie>(repository),
    ),
    ProxyProvider<BookmarkMovieRepositoryImpl,
        DeleteBookmarkDataUseCase<Movie>>(
      update: (context, repository, _) =>
          DeleteBookmarkDataUseCase<Movie>(repository),
    ),
    ProxyProvider<BookmarkMovieRepositoryImpl, SaveBookmarkDataUseCase<Movie>>(
      update: (context, repository, _) =>
          SaveBookmarkDataUseCase<Movie>(repository),
    ),

    // 북마크<인물> 유스케이스
    ProxyProvider<BookmarkPersonRepositoryImpl,
        GetBookmarkDatasUseCase<Person>>(
      update: (context, repository, _) =>
          GetBookmarkDatasUseCase<Person>(repository),
    ),
    ProxyProvider<BookmarkPersonRepositoryImpl,
        FindBookmarkDataUseCase<Person>>(
      update: (context, repository, _) =>
          FindBookmarkDataUseCase<Person>(repository),
    ),
    ProxyProvider<BookmarkPersonRepositoryImpl,
        DeleteBookmarkDataUseCase<Person>>(
      update: (context, repository, _) =>
          DeleteBookmarkDataUseCase<Person>(repository),
    ),
    ProxyProvider<BookmarkPersonRepositoryImpl,
        SaveBookmarkDataUseCase<Person>>(
      update: (context, repository, _) =>
          SaveBookmarkDataUseCase<Person>(repository),
    ),

    // 영화정보 가져오기 유스케이스
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

    ChangeNotifierProvider(
      create: (context) => MovieHomeViewModel(
        context.read<GetMoviePopularUseCase>(),
        context.read<GetMovieNowPlayingUseCase>(),
        context.read<GetGenreUseCase>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => MovieSearchViewModel(
        context.read<GetMovieWithQueryUseCase>(),
        SearchHistoryUseCases(
          saveSearchHistoryUseCase: context.read<SaveSearchHistoryUseCase>(),
          getSearchHistoriesUseCase: context.read<GetSearchHistoriesUseCase>(),
          deleteSearchHistoryUseCase:
              context.read<DeleteSearchHistoryUseCase>(),
          deleteAllHistoryUseCase: context.read<DeleteAllHistoryUseCase>(),
        ),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => MovieBookmarkViewModel(
        context.read<GetBookmarkDatasUseCase<Movie>>(),
        context.read<GetBookmarkDatasUseCase<Person>>(),
        context.read<GetReviewsUseCase>(),
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => AuthViewModel(),
    ),
  ];

  return providers;
}

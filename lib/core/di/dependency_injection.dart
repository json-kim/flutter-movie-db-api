// 1. Provider 전체
import 'package:movie_search/data/data_source/local/movie_local_data_source.dart';
import 'package:movie_search/data/data_source/local/person_local_data_source.dart';
import 'package:movie_search/data/data_source/local/review_local_data_source.dart';
import 'package:movie_search/data/data_source/local/search_history_local_data_source.dart';
import 'package:movie_search/data/data_source/local/token_local_data_source.dart';
import 'package:movie_search/data/data_source/remote/auth/apple_auth_api.dart';
import 'package:movie_search/data/data_source/remote/auth/google_auth_api.dart';
import 'package:movie_search/data/data_source/remote/auth/kakao_auth_api.dart';
import 'package:movie_search/data/data_source/remote/auth/kakao_user_api.dart';
import 'package:movie_search/data/data_source/remote/auth/naver_auth_api.dart';
import 'package:movie_search/data/data_source/remote/auth/naver_user_api.dart';
import 'package:movie_search/data/data_source/remote/firebase/backup_remote_data_source.dart';
import 'package:movie_search/data/data_source/remote/firebase/firebase_auth_remote_data_source.dart';
import 'package:movie_search/data/data_source/remote/movie_remote_data_source.dart';
import 'package:movie_search/data/repository/auth/apple_auth_repository_impl.dart';
import 'package:movie_search/data/repository/auth/fauth_repository_impl.dart';
import 'package:movie_search/data/repository/auth/google_auth_repository_impl.dart';
import 'package:movie_search/data/repository/auth/kakao_auth_repository_impl.dart';
import 'package:movie_search/data/repository/auth/naver_auth_repository_impl.dart';
import 'package:movie_search/data/repository/backup/backup_repository_impl.dart';
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
import 'package:movie_search/domain/usecase/auth/apple_login_use_case.dart';
import 'package:movie_search/domain/usecase/auth/email_login_use_case.dart';
import 'package:movie_search/domain/usecase/auth/find_pw_use_case.dart';
import 'package:movie_search/domain/usecase/auth/google_login_use_case.dart';
import 'package:movie_search/domain/usecase/auth/kakao_login_use_case.dart';
import 'package:movie_search/domain/usecase/auth/logout_use_case.dart';
import 'package:movie_search/domain/usecase/auth/naver_login_use_case.dart';
import 'package:movie_search/domain/usecase/auth/sign_up_use_case.dart';
import 'package:movie_search/domain/usecase/backup/delete_backup_use_case.dart';
import 'package:movie_search/domain/usecase/backup/load_backup_data_use_case.dart';
import 'package:movie_search/domain/usecase/backup/load_backup_list_use_case.dart';
import 'package:movie_search/domain/usecase/backup/restore_backup_data_use_case.dart';
import 'package:movie_search/domain/usecase/backup/save_backup_use_case.dart';
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
import 'package:movie_search/domain/usecase/movie/get_movie_upcoming_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_with_genre_use_case.dart';
import 'package:movie_search/domain/usecase/movie/get_movie_with_query_use_case.dart';
import 'package:movie_search/domain/usecase/person/get_person_detail_use_case.dart';
import 'package:movie_search/domain/usecase/reset_use_case.dart';
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
import 'package:movie_search/presentation/movie_soon/movie_soon_view_model.dart';
import 'package:movie_search/presentation/setting/setting_view_model.dart';
import 'package:movie_search/service/hive_service.dart';
import 'package:movie_search/service/package_info_service.dart';
import 'package:movie_search/service/sql_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

Future<List<SingleChildWidget>> setProvider() async {
  await PackageInfoService.instance.init();
  await SqlService.instance.init();
  final db = SqlService.instance.db;

  await HiveService.instance.init();
  final box = HiveService.instance.searchBox;

  // **********
  // 데이터 소스
  // **********
  final tokenLocalDataSource = TokenLocalDataSource.instance;
  final firebaseAuthRemoteDataSource = FirebaseAuthRemoteDataSource();
  final kakaoAuthApi = KakaoAuthApi.instance;
  final kakaoUserApi = KakaoUserApi.instance;
  final naverAuthApi = NaverAuthApi.instance;
  final naverUserApi = NaverUserApi.instance;
  final googleAuthApi = GoogleAuthApi();
  final appleAuthApi = AppleAuthApi();
  final movieRemoteDataSource = MovieRemoteDataSource();
  final movieLocalDataSource = MovieLocalDataSource(db!);
  final personLocalDataSource = PersonLocalDataSource(db);
  final reviewLocalDataSource = ReviewLocalDataSource(db);
  final searchHistoryLocalDataSource = SearchHistoryLocalDataSource(box!);
  final backupDataRemoteDataSource = BackupRemoteDataSource();

  // **********
  // 레포지토리
  // **********
  final fauthRepository = FAuthRepositoryImpl(firebaseAuthRemoteDataSource);
  final kakaoRepository = KakaoAuthRepositoryImpl(
    kakaoAuthApi,
    kakaoUserApi,
    tokenLocalDataSource,
  );
  final naverRepository = NaverAuthRepositoryImpl(
    naverAuthApi,
    naverUserApi,
    tokenLocalDataSource,
  );
  final googleRepository = GoogleAuthRepositoryImpl(googleAuthApi);
  final appleRepository = AppleAuthRepositoryImpl(appleAuthApi);
  final searchHistoryRepository =
      SearchHistoryRepositoryImpl(searchHistoryLocalDataSource);
  final reviewDataRepository = ReviewDataRepositoryImple(reviewLocalDataSource);
  final bookmarkDataRepository =
      BookmarkMovieRepositoryImpl(movieLocalDataSource);
  final bookmarkPersonRepository =
      BookmarkPersonRepositoryImpl(personLocalDataSource);
  final movieDataRepository = MovieDataRepositoryImpl(movieRemoteDataSource);
  final genreDataRepository = GenreDataRepositoryImpl(movieRemoteDataSource);
  final movieDetailDataRepository =
      MovieDetailDataRepositoryImpl(movieRemoteDataSource);
  final creditDataRepository = CreditDataRepositoryImpl(movieRemoteDataSource);
  final videoDataRepository = VideoDataRepositoryImpl(movieRemoteDataSource);
  final personDataRepository = PersonDataRepositoryImpl(movieRemoteDataSource);
  final castDataRepository = CastDataRepositoryImpl(movieRemoteDataSource);
  final backupRepository = BackupRepositoryImpl(backupDataRemoteDataSource);

  // **********
  // 유스케이스
  // **********
  final kakaoLoginUseCase = KakaoLoginUseCase(
    kakaoRepository,
    fauthRepository,
  );
  final naverLoginUseCase = NaverLoginUseCase(
    naverRepository,
    fauthRepository,
  );
  final googleLoginUseCase = GoogleLoginUseCase(googleRepository);
  final appleLoginUseCase = AppleLoginUseCase(appleRepository);
  final logoutUseCase = LogoutUseCase(
    googleRepository,
    appleRepository,
    kakaoRepository,
    naverRepository,
  );
  final emailLoginUseCase = EmailLoginUseCase();
  final signUpUseCase = SignUpUseCase();
  final findPWUseCase = FindPWUseCase();
  final saveBackupUseCase = SaveBackupUseCase(backupRepository,
      bookmarkDataRepository, bookmarkPersonRepository, reviewDataRepository);
  final loadBackupDataUseCase = LoadBackupDataUseCase(backupRepository);
  final loadBackupListUseCase = LoadBackupListUseCase(backupRepository);
  final deleteBackupUseCase = DeleteBackupUseCase(backupRepository);
  final restoreBackupDataUseCase = RestoreBackupDataUseCase(
      bookmarkDataRepository,
      bookmarkPersonRepository,
      reviewDataRepository,
      loadBackupDataUseCase);
  final resetUseCase = ResetUseCase(
      bookmarkDataRepository, bookmarkPersonRepository, reviewDataRepository);

  List<SingleChildWidget> usecaseProviders = [
    // **********
    // 검색 기록 유스케이스
    // **********
    Provider(
        create: (context) =>
            GetSearchHistoriesUseCase(searchHistoryRepository)),
    Provider(
        create: (context) => DeleteSearchHistoryUseCase(
              searchHistoryRepository,
            )),
    Provider(
      create: (context) => DeleteAllHistoryUseCase(searchHistoryRepository),
    ),
    Provider(
      create: (context) => SaveSearchHistoryUseCase(searchHistoryRepository),
    ),

    // 리뷰 유스케이스
    Provider(
      create: (context) => GetReviewByMovieUseCase(reviewDataRepository),
    ),
    Provider(
      create: (context) => GetReviewsUseCase(reviewDataRepository),
    ),
    Provider(
      create: (context) => CreateReviewUseCase(reviewDataRepository),
    ),
    Provider(
      create: (context) => DeleteReviewUseCase(reviewDataRepository),
    ),
    Provider(
      create: (context) => UpdateReviewUseCase(reviewDataRepository),
    ),
    Provider(
      create: (context) => CreateReviewUseCase(reviewDataRepository),
    ),

    // **********
    // 북마크<영화> 유스케이스
    // **********
    Provider(
      create: (context) =>
          GetBookmarkDatasUseCase<Movie>(bookmarkDataRepository),
    ),
    Provider(
      create: (context) =>
          FindBookmarkDataUseCase<Movie>(bookmarkDataRepository),
    ),
    Provider(
      create: (context) =>
          DeleteBookmarkDataUseCase<Movie>(bookmarkDataRepository),
    ),
    Provider(
      create: (context) =>
          SaveBookmarkDataUseCase<Movie>(bookmarkDataRepository),
    ),

    // **********
    // 북마크<인물> 유스케이스
    // **********
    Provider(
      create: (context) =>
          GetBookmarkDatasUseCase<Person>(bookmarkPersonRepository),
    ),
    Provider(
      create: (context) =>
          FindBookmarkDataUseCase<Person>(bookmarkPersonRepository),
    ),
    Provider(
      create: (context) =>
          DeleteBookmarkDataUseCase<Person>(bookmarkPersonRepository),
    ),
    Provider(
      create: (context) =>
          SaveBookmarkDataUseCase<Person>(bookmarkPersonRepository),
    ),

    // **********
    // 영화정보 가져오기 유스케이스
    // **********
    Provider(
      create: (context) => GetPersonDetailUseCase(personDataRepository),
    ),
    Provider(
      create: (context) => GetCastWithPersonUseCase(castDataRepository),
    ),
    Provider(
      create: (context) => GetVideoWithMovieUseCase(videoDataRepository),
    ),
    Provider(
      create: (context) => GetCreditWithMovieUseCase(creditDataRepository),
    ),
    Provider(
      create: (context) => GetMoviePopularUseCase(movieDataRepository),
    ),
    Provider(
      create: (context) => GetMovieWithQueryUseCase(movieDataRepository),
    ),
    Provider(
      create: (context) => GetMovieNowPlayingUseCase(movieDataRepository),
    ),
    Provider(
      create: (context) => GetMovieUpcomingUseCase(movieDataRepository),
    ),
    Provider(
      create: (context) => GetMovieWithGenreUseCase(movieDataRepository),
    ),
    Provider(
      create: (context) => GetMovieSimilarUseCase(movieDataRepository),
    ),
    Provider(
      create: (context) => GetGenreUseCase(genreDataRepository),
    ),
    Provider(
      create: (context) => GetMovieDetailUseCase(movieDetailDataRepository),
    ),
  ];

  // **********
  // 뷰모델
  // **********
  final List<SingleChildWidget> viewModelProviders = [
    ChangeNotifierProvider(
      create: (context) => MovieHomeViewModel(
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
        context.read<DeleteReviewUseCase>(),
      ),
    ),
    ChangeNotifierProvider<AuthViewModel>(
      create: (context) => AuthViewModel(
        googleLoginUseCase,
        appleLoginUseCase,
        kakaoLoginUseCase,
        naverLoginUseCase,
        emailLoginUseCase,
        logoutUseCase,
        signUpUseCase,
        findPWUseCase,
      ),
    ),
    ChangeNotifierProvider<SettingViewModel>(
      create: (context) => SettingViewModel(
        saveBackupUseCase,
        loadBackupListUseCase,
        restoreBackupDataUseCase,
        deleteBackupUseCase,
        resetUseCase,
      ),
    ),
    ChangeNotifierProvider(
      create: (context) => MovieSoonViewModel(
        context.read<GetMovieUpcomingUseCase>(),
      ),
    ),
  ];

  return [...usecaseProviders, ...viewModelProviders];
}

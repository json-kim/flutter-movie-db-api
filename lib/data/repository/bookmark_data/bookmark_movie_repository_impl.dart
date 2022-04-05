import 'package:movie_search/core/result/result.dart';
import 'package:movie_search/data/data_source/local/entity/movie_db_entity.dart';
import 'package:movie_search/data/data_source/local/movie_local_data_source.dart';
import 'package:movie_search/domain/model/movie/movie.dart';
import 'package:movie_search/domain/repository/bookmark_data_repository.dart';

class BookmarkMovieRepositoryImpl
    implements BookmarkDataRepository<Movie, int> {
  final MovieLocalDataSource _dataSource;

  BookmarkMovieRepositoryImpl(this._dataSource);

  @override
  Future<Result<int>> deleteData(int movieId) async {
    final result = await _dataSource.deleteMovie(movieId);

    return result.when(
      success: (delResult) {
        return Result.success(delResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<Movie>> loadData(int movieId) async {
    final result = await _dataSource.getMovieById(movieId);

    return result.when(
      success: (entity) {
        try {
          final Movie movie = entity.toMovie();
          return Result.success(movie);
        } catch (e) {
          return Result.error(
              '$runtimeType : loadData() 에러 발생 \n Movie 파싱 에러 \n${e.toString()}');
        }
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<List<Movie>>> loadDataList(int page) async {
    final result = await _dataSource.getMovies(page);

    return result.when(
      success: (entities) {
        try {
          final List<Movie> movies =
              entities.map((entity) => entity.toMovie()).toList();

          return Result.success(movies);
        } catch (e) {
          return Result.error(
              '$runtimeType : loadDataList() 에러 발생 \n Entity => Movie 파싱 에러 \n ${e.toString()}');
        }
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<int>> saveData(Movie movie) async {
    try {
      final movieEntity = MovieDbEntity.fromMovie(movie);

      final result = await _dataSource.insertMovie(movieEntity);

      return result.when(
        success: (saveResult) {
          return Result.success(saveResult);
        },
        error: (message) {
          return Result.error(message);
        },
      );
    } catch (e) {
      return Result.error(
          '$runtimeType : saveData() 에러 발생 \n Movie => Entity 파싱 에러 \n ${e.toString()}');
    }
  }

  @override
  Future<Result<List<Movie>>> loadAllDatas() async {
    final result = await _dataSource.getAllMovies();

    return result.when(
      success: (entities) {
        try {
          final List<Movie> movies =
              entities.map((entity) => entity.toMovie()).toList();

          return Result.success(movies);
        } catch (e) {
          return Result.error(
              '$runtimeType : loadAllDatas() 에러 발생 \n Entity => Movie 파싱 에러 \n ${e.toString()}');
        }
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<void>> restoreDatas(List<Movie> datas) async {
    final entities =
        datas.map((movie) => MovieDbEntity.fromMovie(movie)).toList();

    final result = await _dataSource.restoreMovies(entities);

    return result.when(
      success: (restoreResult) {
        return Result.success(restoreResult);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }

  @override
  Future<Result<void>> deleteAll() async {
    final result = await _dataSource.deleteAllMovies();

    return result.when(
      success: (_) {
        return Result.success(null);
      },
      error: (message) {
        return Result.error(message);
      },
    );
  }
}

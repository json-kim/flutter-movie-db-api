import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlService {
  Database? _db;

  Database? get db => _db;

  SqlService._();

  static SqlService _instance = SqlService._();

  static SqlService get instance => _instance;

  Future<void> init() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'movie_person.db');
    await deleteDatabase(path);
    // open the database
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          '''
          CREATE TABLE movie(
            id INTEGER PRIMARY KEY,
            title TEXT NOT NULL,
            posterPath TEXT,
            backdropPath TEXT,
            adult INTEGER NOT NULL,
            genreIds TEXT,
            originalLanguage TEXT,
            originalTitle TEXT,
            overview TEXT,
            popularity REAL,
            releaseDate TEXT,
            video INTEGER,
            voteAverage REAL,
            voteCount INTEGER,
            bookmarkTime INTEGER
          )
          ''',
        );

        await db.execute(
          '''
          CREATE TABLE person(
            id INTEGER PRIMARY KEY,
            gender INTEGER NOT NULL,
            deathday TEXT,
            birthday TEXT,
            biography TEXT NOT NULL,
            homepage TEXT,
            imdbId TEXT NOT NULL,
            knownForDepartment TEXT NOT NULL,
            name TEXT NOT NULL,
            placeOfBirth TEXT,
            popularity REAL NOT NULL,
            profilePath TEXT,
            adult INTEGER NOT NULL,
            alsoKnownAs NOT NULL
          )
          ''',
        );

        await db.execute(
          '''
          CREATE TABLE review(
            id TEXT PRIMARY KEY,
            movieId INTEGER NOT NULL,
            starRating REAL NOT NULL,
            content TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            viewingDate TEXT NOT NULL
          )
          ''',
        );
      },
    );
  }
}

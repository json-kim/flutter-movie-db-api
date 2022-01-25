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
    String path = join(databasesPath, 'demo.db');

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
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:movie_search/data/tmdb_api.dart';
import 'package:movie_search/ui/movie_search/movie_search_screen.dart';
import 'package:movie_search/ui/movie_search/movie_search_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (_) => MovieSearchViewModel(movieDBApi: TMDBApi()),
        child: const MovieSearchScreen(),
      ),
    );
  }
}

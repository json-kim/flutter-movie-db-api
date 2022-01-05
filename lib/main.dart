import 'package:flutter/material.dart';
import 'package:movie_search/core/dependency_injection.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/data/tmdb_api.dart';
import 'package:movie_search/presentation/movie_search/movie_search_view_model.dart';
import 'package:movie_search/presentation/movie_tab_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: globalProviders,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kMaterialApptitle,
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
      home: ChangeNotifierProvider(
        create: (_) => MovieSearchViewModel(movieDBApi: TMDBApi()),
        child: const MovieTabScreen(),
      ),
    );
  }
}

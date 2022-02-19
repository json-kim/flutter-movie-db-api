import 'package:flutter/material.dart';
import 'package:movie_search/presentation/movie_detail/movie_detail_screen.dart';

class MovieNestedScreen extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MovieNestedScreen({required this.navigatorKey, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: generateRoute,
    );
  }

  Route generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
        builder: (context) => MovieDetailScreen(
              navigatorKey: navigatorKey,
            ));
  }
}

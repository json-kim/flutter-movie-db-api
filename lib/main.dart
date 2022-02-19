import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movie_search/core/di/dependency_injection.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/presentation/movie_tab_screen.dart';
import 'package:movie_search/ui/navigator_key.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final globalProviders = await setProvider();

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
      navigatorKey: NavigatorKey.navigatorKeyMain,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ko', 'KR'),
      ],
      title: kMaterialApptitle,
      theme: ThemeData.dark().copyWith(
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent, elevation: 0)),
      darkTheme: ThemeData.dark(),
      home: const MovieTabScreen(),
    );
  }
}

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:movie_search/core/di/dependency_injection.dart';
import 'package:movie_search/core/util/constants.dart';
import 'package:movie_search/presentation/auth/auth_screen.dart';
import 'package:movie_search/presentation/movie_tab_screen.dart';
import 'package:movie_search/ui/navigator_key.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'core/http_override.dart';
import 'presentation/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();
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
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return MaterialApp(
                darkTheme: ThemeData.dark(),
                home: ResponsiveSizer(
                  builder: (context, orientation, screenType) => AuthScreen(),
                ));
          }

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
            home: ResponsiveSizer(
              builder: (context, orientation, screenType) => const AuthGate(),
            ),
          );
        });
  }
}

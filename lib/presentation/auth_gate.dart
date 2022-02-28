import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_search/presentation/auth/auth_screen.dart';
import 'package:movie_search/presentation/movie_tab_screen.dart';
import 'package:movie_search/presentation/user/user_view_model.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const AuthScreen();
        }

        return Provider<UserViewModel>(
          create: (context) => UserViewModel(snapshot.data!),
          child: const MovieTabScreen(),
        );
      },
    );
  }
}

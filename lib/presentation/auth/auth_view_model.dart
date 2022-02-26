import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_search/presentation/auth/auth_event.dart';

class AuthViewModel with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void onEvent(AuthEvent event) {
    event.when(
      signInGoogle: _signInGoogle,
      signInApple: _signInApple,
      signInKakao: _signInKakao,
      signInNaver: _signInNaver,
      signOut: _signOut,
    );
  }

  Future<void> _signInGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      // TODO: 로그인 실패
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser.authentication;

    if (googleAuth == null) {
      // TODO: 로그인 실패
      return;
    }

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> _signInApple() async {}

  Future<void> _signInKakao() async {}

  Future<void> _signInNaver() async {}

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}

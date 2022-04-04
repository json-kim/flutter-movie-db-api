import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_search/domain/model/auth/user_model.dart';
import 'package:movie_search/domain/usecase/auth/apple_login_use_case.dart';
import 'package:movie_search/domain/usecase/auth/google_login_use_case.dart';
import 'package:movie_search/domain/usecase/auth/kakao_login_use_case.dart';
import 'package:movie_search/domain/usecase/auth/logout_use_case.dart';
import 'package:movie_search/domain/usecase/auth/naver_login_use_case.dart';

import 'auth_event.dart';

class AuthViewModel with ChangeNotifier {
  final GoogleLoginUseCase _googleLoginUseCase;
  final AppleLoginUseCase _appleLoginUseCase;
  final KakaoLoginUseCase _kakaoLoginUseCase;
  final NaverLoginUseCase _naverLoginUseCase;
  final LogoutUseCase _logoutUseCase;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  bool isLoading = false;

  UserModel get user => UserModel(
        email: _firebaseAuth.currentUser?.email ?? '',
        userName: _firebaseAuth.currentUser?.displayName ?? '유저',
        photoUrl: _firebaseAuth.currentUser?.photoURL ?? '',
      );

  AuthViewModel(
    this._googleLoginUseCase,
    this._appleLoginUseCase,
    this._kakaoLoginUseCase,
    this._naverLoginUseCase,
    this._logoutUseCase,
  );

  void onEvent(AuthEvent event) {
    event.when(
      loginWithGoogle: _loginWithGoogle,
      loginWithApple: _loginWithApple,
      loginWithKakao: _loginWithKakao,
      loginWithNaver: _loginWithNaver,
      loginWithFacebook: _loginWithFacebook,
      loginWithTwitter: _loginWithTwitter,
      loginWithYahoo: _loginWithYahoo,
      logout: _logout,
    );
  }

  Future<void> _loginWithGoogle() async {
    isLoading = true;
    notifyListeners();

    await _googleLoginUseCase();

    isLoading = false;
    notifyListeners();
  }

  Future<void> _loginWithApple() async {
    isLoading = true;
    notifyListeners();

    await _appleLoginUseCase();

    isLoading = false;
    notifyListeners();
  }

  Future<void> _loginWithKakao() async {
    isLoading = true;
    notifyListeners();

    await _kakaoLoginUseCase();

    isLoading = false;
    notifyListeners();
  }

  Future<void> _loginWithNaver() async {
    isLoading = true;
    notifyListeners();

    await _naverLoginUseCase();

    isLoading = false;
    notifyListeners();
  }

  Future<void> _loginWithFacebook() async {}
  Future<void> _loginWithTwitter() async {}
  Future<void> _loginWithYahoo() async {}

  Future<void> _logout() async {
    isLoading = true;
    notifyListeners();

    final result = await _logoutUseCase();

    result.when(
        success: (_) {},
        error: (error) {
          print('TODO: 로그 아웃 에러');
        });

    isLoading = false;
    notifyListeners();
  }
}

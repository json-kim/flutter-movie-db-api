import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_search/domain/model/auth/user_model.dart';
import 'package:movie_search/domain/usecase/auth/apple_login_use_case.dart';
import 'package:movie_search/domain/usecase/auth/email_login_use_case.dart';
import 'package:movie_search/domain/usecase/auth/find_pw_use_case.dart';
import 'package:movie_search/domain/usecase/auth/google_login_use_case.dart';
import 'package:movie_search/domain/usecase/auth/kakao_login_use_case.dart';
import 'package:movie_search/domain/usecase/auth/logout_use_case.dart';
import 'package:movie_search/domain/usecase/auth/naver_login_use_case.dart';
import 'package:movie_search/domain/usecase/auth/sign_up_use_case.dart';
import 'package:movie_search/presentation/auth/auth_ui_event.dart';

import 'auth_event.dart';

class AuthViewModel with ChangeNotifier {
  final GoogleLoginUseCase _googleLoginUseCase;
  final AppleLoginUseCase _appleLoginUseCase;
  final KakaoLoginUseCase _kakaoLoginUseCase;
  final NaverLoginUseCase _naverLoginUseCase;
  final EmailLoginUseCase _emailLoginUseCase;
  final LogoutUseCase _logoutUseCase;
  final SignUpUseCase _signUpUseCase;
  final FindPWUseCase _findPWUseCase;
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
    this._emailLoginUseCase,
    this._logoutUseCase,
    this._signUpUseCase,
    this._findPWUseCase,
  );

  final _uiEventController = StreamController<AuthUiEvent>.broadcast();
  Stream<AuthUiEvent> get uiEvent => _uiEventController.stream;
  final _signUpEventController = StreamController<AuthUiEvent>.broadcast();
  Stream<AuthUiEvent> get signUpEvent => _signUpEventController.stream;
  final _findPWEventController = StreamController<AuthUiEvent>.broadcast();
  Stream<AuthUiEvent> get findPWEvent => _findPWEventController.stream;

  @override
  void dispose() {
    _uiEventController.close();
    _signUpEventController.close();
    _findPWEventController.close();
    super.dispose();
  }

  void onEvent(AuthEvent event) {
    event.when(
      loginWithEmail: _loginWithEmail,
      loginWithGoogle: _loginWithGoogle,
      loginWithApple: _loginWithApple,
      loginWithKakao: _loginWithKakao,
      loginWithNaver: _loginWithNaver,
      loginWithFacebook: _loginWithFacebook,
      loginWithTwitter: _loginWithTwitter,
      loginWithYahoo: _loginWithYahoo,
      logout: _logout,
      signup: _signUp,
      findPW: _findPW,
    );
  }

  Future<void> _loginWithEmail(String email, String password) async {
    isLoading = true;
    notifyListeners();

    final result = await _emailLoginUseCase(email, password);

    result.when(
        success: (_) {},
        error: (message) {
          _uiEventController.add(AuthUiEvent.snackBar(message));
        });

    isLoading = false;
    notifyListeners();
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

  Future<void> _signUp(String email, String password, String nickName) async {
    isLoading = true;
    notifyListeners();

    final result = await _signUpUseCase(email, password, nickName);

    result.when(
        success: (_) {},
        error: (message) {
          _signUpEventController.add(AuthUiEvent.snackBar(message));
        });

    isLoading = false;
    notifyListeners();
  }

  Future<void> _findPW(String email) async {
    isLoading = true;
    notifyListeners();

    final result = await _findPWUseCase(email);

    result.when(success: (_) {
      _findPWEventController.add(AuthUiEvent.snackBar('메일이 발송되었습니다.'));
    }, error: (message) {
      _findPWEventController.add(AuthUiEvent.snackBar(message));
    });

    isLoading = false;
    notifyListeners();
  }
}

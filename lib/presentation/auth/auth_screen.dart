import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:movie_search/presentation/auth/find_pw_screen.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'auth_event.dart';
import 'auth_view_model.dart';
import 'signin_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> _messengerKey =
      GlobalKey<ScaffoldMessengerState>();
  StreamSubscription? _subscription;
  late Image iconImage;

  @override
  void initState() {
    iconImage = Image.asset('asset/icon/vector_icon.png');

    Future.microtask(() async {
      final viewModel = context.read<AuthViewModel>();

      _subscription = viewModel.uiEvent.listen((event) {
        event.when(snackBar: (message) {
          final snackBar = SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(message),
          );

          _messengerKey.currentState
            ?..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        });
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(iconImage.image, context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _subscription?.cancel();
    super.dispose();
  }

  void _loginWithEmail() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      return;
    }

    context
        .read<AuthViewModel>()
        .onEvent(AuthEvent.loginWithEmail(email, password));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();

    return ScaffoldMessenger(
      key: _messengerKey,
      child: Scaffold(
        body: Center(
          child: Stack(
            children: [
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 로고 이미지
                      SizedBox(width: 40.w, child: iconImage),
                      const SizedBox(height: 48),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 4),
                              child: TextFormField(
                                controller: _emailController,
                                validator: (text) {
                                  if (text?.isEmpty ?? false) {
                                    return '이메일을 입력해주세요';
                                  }

                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  labelText: '이메일',
                                  labelStyle: TextStyle(color: Colors.white),
                                  fillColor: Colors.white10,
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.mail,
                                    color: Colors.white,
                                  ),
                                ),
                                cursorColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 4),
                              child: TextFormField(
                                controller: _passwordController,
                                validator: (text) {
                                  if (text?.isEmpty ?? false) {
                                    return '비밀번호를 입력해주세요';
                                  }

                                  return null;
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Colors.transparent)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.red)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide:
                                          BorderSide(color: Colors.white)),
                                  labelText: '비밀번호',
                                  labelStyle: TextStyle(color: Colors.white),
                                  fillColor: Colors.white10,
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.lock,
                                    color: Colors.white,
                                  ),
                                ),
                                cursorColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: _loginWithEmail,
                          child: Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                '로그인',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SignInScreen(),
                                  ));
                                },
                                child: Text(
                                  '회원가입',
                                  style: TextStyle(color: Colors.white),
                                )),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => FindPWScreen(),
                                ));
                              },
                              child: Text(
                                '비밀번호 찾기',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                        height: 1,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 60.w,
                        child: SignInButton(Buttons.Google, text: '구글 로그인',
                            onPressed: () {
                          viewModel.onEvent(const AuthEvent.loginWithGoogle());
                        }),
                      ),
                      SizedBox(
                        width: 60.w,
                        child: SignInButton(Buttons.Apple, text: '애플 로그인',
                            onPressed: () {
                          viewModel.onEvent(const AuthEvent.loginWithApple());
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: InkWell(
                          child: Container(
                            width: 60.w,
                            height: 36,
                            decoration: BoxDecoration(
                                color: Color(0xFFFEE500),
                                borderRadius: BorderRadius.circular(4)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '카카오 로그인',
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            viewModel.onEvent(const AuthEvent.loginWithKakao());
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          child: Container(
                            width: 60.w,
                            height: 36,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(3, 199, 90, 1),
                                borderRadius: BorderRadius.circular(4)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text('네이버 로그인')],
                            ),
                          ),
                          onTap: () {
                            viewModel.onEvent(const AuthEvent.loginWithNaver());
                          },
                        ),
                      ),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       viewModel.onEvent(const AuthEvent.loginWithFacebook());
                      //     },
                      //     child: const Text('페이스북 로그인')),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       viewModel.onEvent(const AuthEvent.loginWithTwitter());
                      //     },
                      //     child: const Text('트위터 로그인')),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       viewModel.onEvent(const AuthEvent.loginWithYahoo());
                      //     },
                      //     child: const Text('야후 로그인')),
                    ],
                  ),
                ),
              ),
              if (viewModel.isLoading)
                Container(
                  color: Colors.white.withOpacity(0.2),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

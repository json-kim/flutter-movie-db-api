import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_search/presentation/auth/auth_event.dart';
import 'package:movie_search/ui/ui_constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:provider/provider.dart';

import 'auth_view_model.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _pwController = TextEditingController();
  final _nickController = TextEditingController();
  StreamSubscription? _subscription;

  @override
  void initState() {
    Future.microtask(() async {
      final viewModel = context.read<AuthViewModel>();

      _subscription = viewModel.signUpEvent.listen((event) {
        event.when(snackBar: (message) {
          final snackBar = SnackBar(
            content: Text(message),
            behavior: SnackBarBehavior.floating,
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
  void dispose() {
    _subscription?.cancel();
    _emailController.dispose();
    _pwController.dispose();
    _nickController.dispose();
    super.dispose();
  }

  void _signUp() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final email = _emailController.text;
    final pw = _pwController.text;
    final nick = _nickController.text;

    context.read<AuthViewModel>().onEvent(AuthEvent.signup(email, pw, nick));
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();

    return ScaffoldMessenger(
      key: _messengerKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('회원가입'),
          elevation: 0,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // **********
                            // 이메일
                            // **********
                            Text('이메일 주소'),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (text) {
                                if (text?.isEmpty ?? true) {
                                  return '이메일을 입력해주세요';
                                }
                                final emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(text!);

                                if (!emailValid) {
                                  return '올바른 형식의 이메일을 입력해주세요';
                                }

                                return null;
                              },
                              cursorColor: Colors.white,
                              decoration: formDecoration.copyWith(
                                hintText: '\'@\'를 포함한 이메일 주소를 입력해주세요',
                              ),
                            ),
                            const SizedBox(height: 36),

                            // **********
                            // 비밀번호
                            // **********
                            Text('로그인 비밀번호'),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _pwController,
                              validator: (text) {
                                if (text == null) {
                                  return '비밀번호를 입력해주세요';
                                }

                                if (text.length < 6 || text.length > 12) {
                                  return '비밀번호는 6~12자로 설정해주세요';
                                }

                                return null;
                              },
                              cursorColor: Colors.white,
                              obscureText: true,
                              decoration: formDecoration.copyWith(
                                hintText: '비밀번호는 6~12자로 설정해주세요',
                              ),
                            ),
                            const SizedBox(height: 36),

                            // **********
                            // 비밀번호 확인
                            // **********
                            Text('로그인 비밀번호 재입력'),
                            const SizedBox(height: 8),
                            TextFormField(
                              validator: (text) {
                                if (text == null) {
                                  return '비밀번호를 입력해주세요';
                                }

                                final pw1 = _pwController.text;
                                if (pw1 != text) {
                                  return '동일한 비밀번호를 입력해주세요';
                                }

                                return null;
                              },
                              cursorColor: Colors.white,
                              obscureText: true,
                              decoration: formDecoration.copyWith(
                                hintText: '비밀번호를 다시 입력해주세요',
                              ),
                            ),
                            const SizedBox(height: 36),

                            // **********
                            // 닉네임
                            // **********
                            Text('닉네임'),
                            const SizedBox(height: 8),
                            TextFormField(
                              validator: (text) {
                                if (text == null) {
                                  return '닉네임을 입력해주세요';
                                }

                                if (text.length < 2 || text.length > 8) {
                                  return '닉네임은 2~8자로 설정해주세요';
                                }

                                return null;
                              },
                              controller: _nickController,
                              cursorColor: Colors.white,
                              decoration: formDecoration.copyWith(
                                hintText: '닉네임은 2~8자로 설정해주세요',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // **********
                // 회원가입 버튼
                // **********
                SafeArea(
                  top: false,
                  bottom: true,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        alignment: Alignment.center,
                        maximumSize: Size(double.infinity, 64),
                        minimumSize: Size(double.infinity, 64),
                        primary: Colors.white,
                        // onSurface: Colors.grey,
                        onPrimary: Colors.grey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _signUp,
                      child: Text(
                        '회원가입',
                        style: TextStyle(fontSize: 18.sp, color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (viewModel.isLoading)
              Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}

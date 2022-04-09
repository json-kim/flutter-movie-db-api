import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'auth_event.dart';
import 'auth_view_model.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late Image iconImage;

  @override
  void initState() {
    iconImage = Image.asset('asset/icon/vector_icon.png');
    super.initState();
  }

  @override
  void didChangeDependencies() {
    precacheImage(iconImage.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 로고 이미지
                  SizedBox(width: 40.w, child: iconImage),
                  const SizedBox(height: 24),
                  Text(
                    '영화 리뷰',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 24),
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
            if (viewModel.isLoading)
              Container(
                color: Colors.white.withOpacity(0.2),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}

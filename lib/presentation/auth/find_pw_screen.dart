import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_search/presentation/auth/auth_event.dart';
import 'package:movie_search/ui/ui_constants.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'auth_view_model.dart';

class FindPWScreen extends StatefulWidget {
  const FindPWScreen({Key? key}) : super(key: key);

  @override
  State<FindPWScreen> createState() => _FindPWScreenState();
}

class _FindPWScreenState extends State<FindPWScreen> {
  final _messengerKey = GlobalKey<ScaffoldMessengerState>();
  final _formKey = GlobalKey<FormState>();
  StreamSubscription? _subscription;

  @override
  void initState() {
    Future.microtask(() async {
      final viewModel = context.read<AuthViewModel>();

      _subscription = viewModel.findPWEvent.listen((event) {
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
    super.dispose();
  }

  void _sendEmail() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    _formKey.currentState?.save();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthViewModel>();

    return ScaffoldMessenger(
      key: _messengerKey,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('비밀번호 찾기'),
          elevation: 0,
        ),
        body: Stack(
          children: [
            Column(children: [
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '본인 확인을 위해 이메일 인증이 필요합니다. \n회원가입시 사용한 이메일 주소를 입력하시고 인증메일 발송 버튼을 클릭해주세요.'),
                          const SizedBox(height: 32),
                          // **********
                          // 이메일
                          // **********
                          Text('이메일'),
                          const SizedBox(height: 8),
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (email) {
                              if (email == null) {
                                return;
                              }

                              viewModel.onEvent(AuthEvent.findPW(email));
                            },
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
                    onPressed: _sendEmail,
                    child: Text(
                      '인증메일 발송',
                      style: TextStyle(fontSize: 18.sp, color: Colors.black),
                    ),
                  ),
                ),
              ),
            ]),
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

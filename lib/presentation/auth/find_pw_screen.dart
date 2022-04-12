import 'package:flutter/material.dart';

class FindPWScreen extends StatelessWidget {
  const FindPWScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('비밀번호 찾기'),
        elevation: 0,
      ),
    );
  }
}

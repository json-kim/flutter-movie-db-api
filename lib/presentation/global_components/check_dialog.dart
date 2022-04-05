import 'package:flutter/material.dart';

class CheckDialog extends StatelessWidget {
  final String content;

  const CheckDialog({required this.content, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('알림'),
      content: Text(content),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('네')),
        TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('아니요')),
      ],
    );
  }
}

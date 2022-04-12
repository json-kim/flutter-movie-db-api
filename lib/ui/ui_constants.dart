import 'package:flutter/material.dart';

final formDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.transparent)),
  border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.transparent)),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.transparent)),
  focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.red)),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: Colors.white)),
  labelStyle: TextStyle(color: Colors.white, fontSize: 14),
  fillColor: Colors.white10,
  filled: true,
);

import 'package:flutter/material.dart';

InputDecoration kTextFieldDecoration() {
  return InputDecoration(
    hintText: " Name",
    contentPadding: EdgeInsets.all(5),
    fillColor: Colors.brown[100],
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );
}
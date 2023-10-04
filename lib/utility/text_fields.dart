import 'package:flutter/material.dart';

InputDecoration kTextFieldDecoration() {
  return InputDecoration(
    hintText: " Name",
    contentPadding: EdgeInsets.all(5),
    fillColor: Colors.brown[100],
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: const BorderSide(color: Colors.blueAccent)
    ),
  );
}
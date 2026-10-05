// ----- STRINGS -----
import 'package:flutter/material.dart';

const baseURL = 'http://127.0.0.1:8000/api';
const loginURL = '$baseURL/login';
const registerURL = '$baseURL/register';
const logoutURL = '$baseURL/logout';
const userURL = '$baseURL/user';
const postsURL = '$baseURL/posts';
const commentsURL = '$baseURL/comments';
// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';

InputDecoration inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    contentPadding: EdgeInsets.all(10),
    border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black)),
  );
}

TextButton textButton(String title, Function onPressed) {
  return TextButton(
    style: ButtonStyle(
      backgroundColor: WidgetStateColor.resolveWith((states) => Colors.blueAccent),
      padding: WidgetStateProperty.resolveWith(
        (states) => EdgeInsets.symmetric(vertical: 10),
      ),
    ),
    onPressed: () => onPressed(),
    child: Text(title, style: TextStyle(color: Colors.white)),
  );
}

import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  DefaultButton({super.key, required this.backgroundColor, required this.text, required this.onPressed, required this.textcolor, required this.width});

  Color? backgroundColor;
  String text;
  Color? textcolor;
  void Function() onPressed;
  double width = 110;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(horizontal: width,)
      ),
      child:
      Text(text,
        style: TextStyle(fontSize: 45, color: textcolor),
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  LoginButton({super.key, required this.onPressed});
  void Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return DefaultButton(
        backgroundColor: Colors.orange[700],
        text: "Login",
        textcolor: Colors.orange[100],
        onPressed: onPressed, width: 120,);
  }
}

class SignupButton extends StatelessWidget {
  SignupButton({super.key, required this.onPressed, required this.backgroundColor, required this.textcolor});
void Function() onPressed;
Color? backgroundColor;
Color? textcolor;
  @override
  Widget build(BuildContext context) {
    return DefaultButton(backgroundColor: backgroundColor, text: "Sign Up", onPressed: onPressed, textcolor: textcolor, width: 50,);
  }
}

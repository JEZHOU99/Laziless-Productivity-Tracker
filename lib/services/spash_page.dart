import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  SplashPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Image.asset(
            "assets/images/Logo.png",
            height: 80,
            width: 80,
          ),
        ),
      ),
    );
  }
}

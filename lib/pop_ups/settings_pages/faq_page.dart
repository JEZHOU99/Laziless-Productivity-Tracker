import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key key, this.user}) : super(key: key);
  final FirebaseUser user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: "FAQ",
          child: Material(
            color: Colors.transparent,
            child: Text(
              "FAQ",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 100),
        child: Column(
          children: <Widget>[
            Flexible(
                child: ListView(
              children: <Widget>[],
            )),
          ],
        ),
      ),
    );
  }
}

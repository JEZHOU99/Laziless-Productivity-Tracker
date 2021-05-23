import 'package:flutter/material.dart';
import 'package:laziless/data/models.dart';
import 'package:laziless/login/sign_up.dart';
import 'package:laziless/main_page.dart';
import 'package:laziless/services/spash_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool loading = true;
  FirebaseUser user;
  Settings settings = Settings();

  @override
  void initState() {
    super.initState();
    print("INITIALISING");
    _getFireBaseUser();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? SplashPage()
        : user == null
            ? SignUpScreen(
                convert: false,
              )
            : MyHomePage();
  }

  _getFireBaseUser() async {
    FirebaseAuth.instance.onAuthStateChanged.listen((firebaseUser) {
      setState(() {
        user = firebaseUser;
        loading = false;
      });
    });
  }
}

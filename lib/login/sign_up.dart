import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:laziless/data/colors.dart';
import 'package:laziless/login/account_check.dart';
import 'package:laziless/login/login.dart';
import 'package:laziless/main.dart';
import 'package:laziless/services/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:laziless/services/fade_in_animation.dart';
import 'package:laziless/services/display_ad.dart';

class SignUpScreen extends StatefulWidget {
  final bool convert;
  SignUpScreen({this.convert});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  bool loading = false;
  String signUpSuccess = "";

  String email = "";
  String password = "";
  String passwordConf = "";
  String feedback = "";

  FocusNode myFocusNode1;
  FocusNode myFocusNode2;
  FocusNode myFocusNode3;

  @override
  void initState() {
    super.initState();

    myFocusNode1 = FocusNode();
    myFocusNode2 = FocusNode();
    myFocusNode3 = FocusNode();

    if (widget.convert == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AccountCheck()),
          ));
    }
    if (widget.convert) {
      Ads.hideBannerAd();
    }
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode1.dispose();
    myFocusNode2.dispose();
    myFocusNode3.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.4, 0.7, 0.9],
            colors: [
              Color(0xFF005A9F),
              Color(0xFF0091A8),
              Color(0xFF1BC6DF),
              Color(0xFF27ABB5)
            ],
          ),
        ),
        child: Stack(children: <Widget>[
          createBackgroundIcon(120, 90, 2.8, FontAwesomeIcons.dumbbell),
          createBackgroundIcon(190, 340, 0.40, FontAwesomeIcons.running),
          createBackgroundIcon(400, 30, 0.3, FontAwesomeIcons.swimmer),
          createBackgroundIcon(170, 140, -0.2, FontAwesomeIcons.bicycle),
          createBackgroundIcon(40, 280, 0.5, FontAwesomeIcons.book),
          createBackgroundIcon(
              340, 340, 0.4, FontAwesomeIcons.chalkboardTeacher),
          createBackgroundIcon(240, 20, -0.4, FontAwesomeIcons.walking),
          Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: FadeDown(
                  delay: 3,
                  child: Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.bottomCenter,
                      child: Image.asset("assets/images/logo_no_back.png")),
                ),
              ),
              Expanded(
                flex: 12,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Form(
                        key: _formkey,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, right: 45.0),
                          child: Scrollbar(
                            child: ListView(
                              physics: BouncingScrollPhysics(),
                              children: <Widget>[
                                FadeIn(
                                  delay: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        60.0, 0, 15, 15),
                                    child: TextFormField(
                                      focusNode: myFocusNode1,
                                      decoration:
                                          logInSignInTextFieldDecoration(
                                              "Email",
                                              FontAwesomeIcons.userCircle),
                                      validator: (val) =>
                                          val.isEmpty ? 'Enter an email' : null,
                                      onChanged: (val) {
                                        setState(() => email = val);
                                      },
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(myFocusNode2);
                                      },
                                    ),
                                  ),
                                ),
                                FadeIn(
                                  delay: 1.2,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        60.0, 0, 15, 15),
                                    child: TextFormField(
                                      focusNode: myFocusNode2,
                                      obscureText: true,
                                      decoration:
                                          logInSignInTextFieldDecoration(
                                              "Password",
                                              FontAwesomeIcons.lock),
                                      validator: (val) => val.length < 6
                                          ? 'Enter a password with more than 6 characters'
                                          : null,
                                      onChanged: (val) {
                                        setState(() => password = val);
                                      },
                                      onFieldSubmitted: (v) {
                                        FocusScope.of(context)
                                            .requestFocus(myFocusNode3);
                                      },
                                    ),
                                  ),
                                ),
                                FadeIn(
                                  delay: 1.4,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        60.0, 0, 15, 15),
                                    child: TextFormField(
                                      focusNode: myFocusNode3,
                                      decoration:
                                          logInSignInTextFieldDecoration(
                                              "Confirm Password",
                                              FontAwesomeIcons.lock),
                                      obscureText: true,
                                      validator: (val) => val.length < 6
                                          ? 'Enter a password with more than 6 characters'
                                          : null,
                                      onChanged: (val) {
                                        setState(() => passwordConf = val);
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    FadeIn(
                      delay: 1.6,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(60, 20, 60, 0),
                        child: loading
                            ? Container(
                                height: 50,
                                color: Colors.transparent,
                                child: Center(
                                  child: SpinKitThreeBounce(
                                    color: Colors.white,
                                    size: 30.0,
                                  ),
                                ))
                            : GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: borderNavy),
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                                onTap: () async {
                                  setState(() {
                                    feedback = "";
                                  });
                                  if (_formkey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                      feedback = "";
                                    });

                                    if (password == passwordConf) {
                                      dynamic result = widget.convert
                                          ? await _auth
                                              .convertWithEmailAndPassword(
                                                  email.trim(), password)
                                          : await _auth
                                              .registerWithEmailAndPassword(
                                                  email.trim(),
                                                  password,
                                                  context);

                                      if (result == null) {
                                        setState(() {
                                          feedback = _auth.errorMsg;
                                          loading = false;
                                        });
                                      } else {
                                        MyApp.restartApp(context);
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                      }
                                    } else {
                                      Scaffold.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Passwords do not match"),
                                              duration: Duration(seconds: 3)));
                                      setState(() {
                                        loading = false;
                                      });
                                    }
                                  }
                                }),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: feedback != ""
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50.0),
                                child: Container(
                                  height: 80,
                                  child: ListView(
                                      physics: BouncingScrollPhysics(),
                                      children: <Widget>[
                                        Text(feedback,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                      ]),
                                ),
                              )
                            : Container(
                                height: 80,
                              )),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: FadeUp(
                        delay: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: widget.convert
                                  ? () async {
                                      setState(() {
                                        loading = true;
                                        feedback = "";
                                      });
                                      dynamic result =
                                          await _auth.convertWithGoogle();
                                      if (result == null) {
                                        setState(() {
                                          feedback = _auth.errorMsg;
                                          loading = false;
                                        });
                                      } else {
                                        setState(() {
                                          feedback =
                                              "Success! Welcome to Laziless";
                                          loading = false;
                                        });

                                        MyApp.restartApp(context);
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                      }
                                    }
                                  : () async {
                                      setState(() {
                                        loading = true;
                                      });
                                      dynamic result =
                                          await _auth.initiateGoogleLogin();

                                      if (result == null) {
                                        setState(() {
                                          feedback = _auth.errorMsg;
                                          loading = false;
                                        });
                                      } else {
                                        setState(() {
                                          feedback =
                                              "Success! Welcome to Laziless";
                                          loading = false;
                                        });
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                      }
                                    },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                child: Container(
                                  width: 130,
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: Color(0xFFde5246)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Icon(FontAwesomeIcons.google,
                                            color: Colors.white),
                                      ),
                                      Text("Google",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: widget.convert
                                  ? () {
                                      Navigator.of(context)
                                          .popUntil((route) => route.isFirst);
                                    }
                                  : () async {
                                      setState(() {
                                        loading = true;
                                      });
                                      dynamic result = await _auth.signInAnon();
                                      if (result == null) {
                                        setState(() {
                                          loading = false;
                                          feedback = _auth.errorMsg;
                                        });
                                      }
                                    },
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 10),
                                child: Container(
                                  width: 130,
                                  height: 50,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: Colors.grey.shade700),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 12),
                                        child: Icon(FontAwesomeIcons.userSecret,
                                            color: Colors.white),
                                      ),
                                      Text("Skip",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 1)),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 20, 20.0),
                  child: FadeUp(
                    delay: 2.4,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Have an Account?",
                          style: TextStyle(color: Colors.white60, fontSize: 14),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    new LoginScreen(convert: widget.convert)));
                          },
                          child: Text(
                            "Log In!",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laziless/services/auth.dart';
import 'package:laziless/data/colors.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:laziless/services/fade_in_animation.dart';
import 'package:laziless/tools/pop_up_close.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class LoginScreen extends StatefulWidget {
  final bool convert;

  LoginScreen({this.convert});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  bool loading = false;

  String email = "";
  String password = "";
  String feedback = "";
  bool passwordReset = false;

  FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
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
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: FadeDown(
                    delay: 4,
                    child: Container(
                        height: 50,
                        width: 50,
                        alignment: Alignment.bottomCenter,
                        child: Image.asset("assets/images/logo_no_back.png")),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Form(
                      key: _formkey,
                      child: Column(
                        children: <Widget>[
                          FadeIn(
                            delay: 1,
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(60.0, 0, 60, 10),
                              child: TextFormField(
                                decoration: logInSignInTextFieldDecoration(
                                    "Email", FontAwesomeIcons.user),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter an email' : null,
                                onChanged: (val) {
                                  setState(() => email = val);
                                },
                                onFieldSubmitted: (v) {
                                  FocusScope.of(context)
                                      .requestFocus(myFocusNode);
                                },
                              ),
                            ),
                          ),
                          passwordReset
                              ? Container()
                              : FadeIn(
                                  delay: 1.2,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        60.0, 0, 60, 20),
                                    child: TextFormField(
                                      focusNode: myFocusNode,
                                      decoration:
                                          logInSignInTextFieldDecoration(
                                              "Password",
                                              FontAwesomeIcons.lock),
                                      obscureText: true,
                                      validator: (val) => val.length < 6
                                          ? 'Enter a password with more than 6 characters'
                                          : null,
                                      onChanged: (val) {
                                        setState(() => password = val);
                                      },
                                    ),
                                  ),
                                ),
                          loading
                              ? Container(
                                  height: 60,
                                  color: Colors.transparent,
                                  child: Center(
                                    child: SpinKitThreeBounce(
                                      color: Colors.white,
                                      size: 30.0,
                                    ),
                                  ))
                              : FadeIn(
                                  delay: 1.4,
                                  child: GestureDetector(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            60, 0, 60, 10),
                                        child: Container(
                                          height: 50,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              color: borderNavy),
                                          child: Text(
                                              passwordReset
                                                  ? "Reset Password"
                                                  : "Log In",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 1)),
                                        ),
                                      ),
                                      onTap: () async {
                                        if (_formkey.currentState.validate()) {
                                          if (passwordReset) {
                                            setState(() {
                                              loading = true;
                                            });
                                            dynamic result = await _auth
                                                .resetPassword(email.trim());

                                            if (result == null) {
                                              setState(() {
                                                feedback = _auth.errorMsg;
                                                loading = false;
                                              });
                                            } else {
                                              setState(() {
                                                feedback =
                                                    "An email has been sent with instructions on resetting your password.";
                                                loading = false;
                                              });
                                            }
                                          } else if (widget.convert == true) {
                                            logInWarning(context, () async {
                                              Navigator.of(context).pop();
                                              setState(() {
                                                loading = true;
                                                feedback = "";
                                              });
                                              FirebaseUser result = await _auth
                                                  .signInWithEmailAndPassword(
                                                email.trim(),
                                                password,
                                              );
                                              if (result == null) {
                                                setState(() {
                                                  feedback = _auth.errorMsg;
                                                  loading = false;
                                                });
                                              } else {
                                                Navigator.of(context).popUntil(
                                                    (route) => route.isFirst);
                                              }
                                            });
                                          } else if (widget.convert == false) {
                                            setState(() {
                                              loading = true;
                                              feedback = "";
                                            });
                                            FirebaseUser result = await _auth
                                                .signInWithEmailAndPassword(
                                              email.trim(),
                                              password,
                                            );
                                            if (result == null) {
                                              setState(() {
                                                feedback = _auth.errorMsg;
                                                loading = false;
                                              });
                                            } else {
                                              Navigator.of(context).popUntil(
                                                  (route) => route.isFirst);
                                            }
                                          }
                                        }
                                      }),
                                ),
                          FadeIn(
                            delay: 1.6,
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(60, 0, 60, 6),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        passwordReset
                                            ? passwordReset = false
                                            : passwordReset = true;
                                      });
                                    },
                                    child: Text(
                                      passwordReset
                                          ? "Nope I remember my password "
                                          : "Forgot Password?",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 12),
                      child: FadeUp(
                        delay: 2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: widget.convert
                                  ? () {
                                      logInWarning(
                                        context,
                                        () async {
                                          Navigator.of(context).pop();
                                          setState(() {
                                            loading = true;
                                          });
                                          dynamic result =
                                              await _auth.initiateGoogleLogin();
                                          if (result == null) {
                                            setState(() {
                                              loading = false;
                                              feedback = _auth.errorMsg;
                                            });
                                          } else {
                                            setState(() {
                                              loading = false;
                                              feedback = "Welcome to Laziless";
                                            });
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                          }
                                        },
                                      );
                                    }
                                  : () async {
                                      setState(() {
                                        loading = true;
                                      });
                                      dynamic result =
                                          await _auth.initiateGoogleLogin();
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
                                        feedback = "";
                                      });
                                      dynamic result = await _auth.signInAnon();
                                      if (result == null) {
                                        setState(() {
                                          feedback = _auth.errorMsg;
                                          loading = false;
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
                  padding: const EdgeInsets.fromLTRB(20.0, 0, 20, 20),
                  child: FadeUp(
                    delay: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Don't Have an Account?",
                          style: TextStyle(color: Colors.white60, fontSize: 14),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Sign Up!",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
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

  logInWarning(context, onConfirm) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                height: 350,
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Warning!",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.red,
                                fontWeight: FontWeight.w600),
                          ),
                          PopUpClose()
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Logging in will erase all your local data in favour of data stored on your log in account. Are you sure you want to continue?",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ConfirmationSlider(
                        onConfirmation: onConfirm,
                        width: 275,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

logInSignInTextFieldDecoration(String hintText, IconData prefixIcon) {
  return InputDecoration(
    prefixIcon: Icon(prefixIcon),
    errorStyle: TextStyle(color: Colors.red),
    hintText: hintText,
    fillColor: Colors.white,
    filled: true,
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(40)),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.circular(40)),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(40)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: borderNavy, width: 2.0),
        borderRadius: BorderRadius.circular(40)),
  );
}

createBackgroundIcon(double top, double left, double rotation, IconData icon) {
  return Positioned(
    top: top,
    left: left,
    child: Transform(
      transform: Matrix4.rotationZ(rotation),
      child: Opacity(
          opacity: 0.10,
          child: Icon(
            icon,
            size: 40,
          )),
    ),
  );
}

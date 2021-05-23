import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:laziless/services/auth.dart';
import 'package:laziless/services/fade_in_animation.dart';

class AccountCheck extends StatefulWidget {
  AccountCheck({Key key}) : super(key: key);

  @override
  _AccountCheckState createState() => _AccountCheckState();
}

class _AccountCheckState extends State<AccountCheck> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    String feedback = "";

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
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
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FadeIn(
                          delay: 1,
                          child: Text(
                            "Hi there! To get the most out of Laziless you will need to register an account",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey.shade200,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        FadeIn(
                          delay: 1.2,
                          child: Text(
                            "With an account you can",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey.shade200,
                                fontSize: 22,
                                fontWeight: FontWeight.w600),
                          ),
                        )
                      ],
                    ),
                  )),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FadeIn(
                          delay: 1.4,
                          child: featureTile(Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.share,
                                size: 36,
                                color: Colors.grey.shade200,
                              ),
                              SizedBox(width: 18),
                              Text(
                                "Save Your Data",
                                style: TextStyle(
                                    color: Colors.grey.shade200, fontSize: 18),
                              ),
                            ],
                          )),
                        ),
                        FadeIn(
                          delay: 1.6,
                          child: featureTile(Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.mobile,
                                size: 36,
                                color: Colors.grey.shade200,
                              ),
                              SizedBox(width: 18),
                              Container(
                                width: 180,
                                child: Text(
                                  "Use Same Account Across Multiple Devices",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontSize: 16),
                                ),
                              ),
                            ],
                          )),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: FadeUp(
                            delay: 2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                RaisedButton(
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 60,
                                    width: 120,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Sign Me Up!",
                                          style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                loading
                                    ? Container(
                                        height: 60,
                                        width: 120,
                                        color: Colors.transparent,
                                        child: Center(
                                          child: SpinKitThreeBounce(
                                            color: Colors.white,
                                            size: 30.0,
                                          ),
                                        ))
                                    : RaisedButton(
                                        color: Colors.grey.shade700,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                        onPressed: () async {
                                          setState(() {
                                            loading = true;
                                          });
                                          dynamic result =
                                              await _auth.signInAnon();
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
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          height: 60,
                                          width: 120,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Maybe Later",
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        )),
                        Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: feedback != ""
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 50.0),
                                    child: Container(
                                      height: 50,
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
                                    height: 50,
                                  )),
                      ],
                    ),
                  ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  featureTile(Row row) {
    return Padding(padding: EdgeInsets.symmetric(vertical: 20), child: row);
  }
}

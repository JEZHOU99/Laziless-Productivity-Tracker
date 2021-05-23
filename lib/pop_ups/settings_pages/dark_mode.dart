import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:laziless/services/dark_theme.dart';
import 'package:provider/provider.dart';

class DarkMode extends StatefulWidget {
  const DarkMode({Key key, this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _DarkModeState createState() => _DarkModeState();
}

class _DarkModeState extends State<DarkMode> {
  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Hero(
          tag: "Dark Mode",
          child: Material(
            color: Colors.transparent,
            child: Text(
              "Dark Mode",
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
        child: Center(
          child: Row(
            children: <Widget>[
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          themeChange.darkTheme = false;
                        },
                        child: Container(
                          height: 250,
                          width: 150,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: AssetImage(
                                  'assets/images/light.png',
                                ),
                              ),
                              border: Border.all(
                                  color: themeChange.darkTheme
                                      ? Colors.grey
                                      : Colors.blue,
                                  width: 4),
                              borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                    ),
                    RadioListTile<bool>(
                      title: Text("Light"),
                      value: false,
                      groupValue: themeChange.darkTheme,
                      onChanged: (bool value) {
                        themeChange.darkTheme = value;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          themeChange.darkTheme = true;
                        },
                        child: Container(
                          height: 250,
                          width: 150,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fitWidth,
                                image: AssetImage(
                                  'assets/images/dark.png',
                                ),
                              ),
                              border: Border.all(
                                  color: themeChange.darkTheme
                                      ? Colors.blue
                                      : Colors.grey,
                                  width: 4),
                              borderRadius: BorderRadius.circular(6)),
                        ),
                      ),
                    ),
                    RadioListTile<bool>(
                      title: Text("Dark"),
                      value: true,
                      groupValue: themeChange.darkTheme,
                      onChanged: (bool value) {
                        themeChange.darkTheme = value;
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

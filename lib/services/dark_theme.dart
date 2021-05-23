import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:laziless/data/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DarkThemePreference {
  static const THEME_STATUS = "THEMESTATUS";

  setDarkTheme(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(THEME_STATUS, value);
  }

  Future<bool> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(THEME_STATUS) ?? false;
  }
}

class DarkThemeProvider with ChangeNotifier {
  DarkThemePreference darkThemePreference = DarkThemePreference();
  bool _darkTheme = false;

  bool get darkTheme => _darkTheme;

  set darkTheme(bool value) {
    _darkTheme = value;
    darkThemePreference.setDarkTheme(value);
    notifyListeners();
  }
}

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
        primaryColor: Color(0xff27ABB5),
        backgroundColor: isDarkTheme ? Color(0xff4D4D4D) : Colors.white,
        cardColor: isDarkTheme ? Color(0xff3E3E3E) : Colors.white,
        canvasColor: isDarkTheme ? Color(0xFF262626) : offWhite,
        dialogBackgroundColor: isDarkTheme ? Color(0xFF262626) : Colors.white,
        brightness: isDarkTheme ? Brightness.dark : Brightness.light,
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme:
                isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
        textSelectionColor:
            isDarkTheme ? Colors.grey.shade300 : Colors.grey.shade800,
        cupertinoOverrideTheme: CupertinoThemeData(
            textTheme: isDarkTheme
                ? CupertinoTextThemeData(
                    primaryColor: Colors.white,
                    pickerTextStyle: TextStyle(color: Colors.white))
                : CupertinoTextThemeData()));
  }
}

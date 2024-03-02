import 'package:flutter/material.dart';
import 'package:samachar/Presentation/themes/themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = darkMode;

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  bool toggleTheme() {
    notifyListeners();
    if (_themeData == lightMode) {
      _themeData = darkMode;
      return true;
    } else {
      _themeData = lightMode;
      return false;
    }
  }
}

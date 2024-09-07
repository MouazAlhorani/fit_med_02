import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

setTheme(SharedPreferences sharedpref, data) async {
  await sharedpref.setString('theme', data);
}

class ThemeProvider extends ChangeNotifier {
  getTheme(SharedPreferences sharedPref) {
    return sharedPref.getString('theme');
  }

  toggoleTheme(SharedPreferences sharedPref) {
    String? currentTheme = getTheme(sharedPref);
    sharedPref.setString('theme',
        currentTheme == null || currentTheme == "light" ? 'dark' : 'light');
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPref;

setDirect(SharedPreferences sharedpref, data) async {
  if (sharedPref != null) {
    await sharedpref.setString('direct', data);
  }
}

class DirectionalityProvider extends ChangeNotifier {
  getDirect(SharedPreferences? sharedPref) {
    if (sharedPref != null) {
      return sharedPref.getString('direct');
    }
  }

  toggoleDirect(SharedPreferences? sharedPref) {
    if (sharedPref != null) {
      String? currentTheme = getDirect(sharedPref);
      sharedPref.setString('direct',
          currentTheme == null || currentTheme == "rtl" ? 'ltr' : 'rtl');
    }
    notifyListeners();
  }

  getDirection(SharedPreferences? sharedPref) {
    if (sharedPref != null) {
      if (getDirect(sharedPref) == 'ltr') {
        return TextDirection.ltr;
      } else {
        return TextDirection.rtl;
      }
    }
  }
}

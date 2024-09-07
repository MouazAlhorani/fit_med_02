import 'package:fit_medicine_02/models/user_model.dart';
import 'package:fit_medicine_02/views/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLoginInfo {
  static save(
      {required SharedPreferences? sharedPref,
      required userkey,
      required password,
      required usertype,
      required user,
      required token}) async {
    if (sharedPref != null) {
      await sharedPref.setStringList(
          'userInfo', [userkey, password, usertype, user, token]);
    }
  }

  static get({required SharedPreferences? sharedPref}) {
    if (sharedPref != null) {
      return sharedPref.getStringList('userInfo');
    }
  }

  static remove({required SharedPreferences? sharedPref, ctx}) async {
    if (sharedPref != null) {
      await sharedPref.remove('userInfo');
      Navigator.pushReplacementNamed(ctx, LoginPage.routeName);
    }
  }
}

VeterModel? veter;
BreederModel? breeder;

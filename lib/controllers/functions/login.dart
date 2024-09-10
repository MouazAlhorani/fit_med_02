import 'dart:convert';

import 'package:fit_medicine_02/controllers/functions/api_requests.dart';
import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/controllers/static/userlogin_Info.dart';
import 'package:fit_medicine_02/views/pages/homepage.dart';
import 'package:flutter/material.dart';

login({String? phone, email, password, required ctx}) async {
  Map? resp = await apiPost(
      ctx: ctx,
      api: "/api/auth/login",
      fields: email == null
          ? {"phone_number": phone!, "password": password}
          : {'email': email, "password": password});
  if (resp != null && resp.containsKey('success') && resp['success'] == true) {
    await UserLoginInfo.save(
        sharedPref: sharedPref,
        userkey: phone ?? email,
        password: password,
        token: resp['data']['data']['auth_token'],
        usertype: resp['data']['data']['user_type'],
        user: jsonEncode(resp['data']['data']['user']),
        id: "${resp['data']['data']['user']['id']}");
    Navigator.pushNamed(ctx, HomePage.routeName);
  } else {
    UserLoginInfo.remove(sharedPref: sharedPref, ctx: ctx);
    if (email != null &&
        resp != null &&
        resp.containsKey("message") &&
        resp['message'].contains('must be a valid email address')) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          showCloseIcon: true,
          content: Text("أدخل صيغة بريد الكتروني صحيحة"),
          elevation: 10,
        ),
      );
    } else if (resp != null && resp.containsKey('data')) {
      if (resp['data']['status_code'] == 404) {
        UserLoginInfo.remove(sharedPref: sharedPref, ctx: ctx);
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(
            showCloseIcon: true,
            content: Text("اسم المستخدم او كلمة المرور غير صحيحة"),
            elevation: 10,
          ),
        );
      }
    }
  }
}

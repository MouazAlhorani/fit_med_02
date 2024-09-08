import 'dart:convert';
import 'dart:io';
import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/controllers/static/server_info.dart';
import 'package:fit_medicine_02/controllers/static/userlogin_Info.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

apiGET(
    {connectType = 'http',
    required String api,
    Map<String, dynamic>? params,
    ctx}) async {
  http.Response? resp;
  Map<String, String> headers = {};
  try {
    headers.addAll({'Accept': 'application/json'});
    if (UserLoginInfo.get(sharedPref: sharedPref) != null) {
      headers.addAll({
        'Authorization':
            'Bearer ${UserLoginInfo.get(sharedPref: sharedPref)[4]}'
      });
    }
    connectType == 'http'
        ? resp =
            await http.get(Uri.http(serverIp, api, params), headers: headers)
        : resp =
            await http.get(Uri.https(serverIp, api, params), headers: headers);
    print(jsonDecode(resp.body));
    var result = jsonDecode(resp.body);
    if (result != null && result['message'] == "Unauthenticated") {
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        showCloseIcon: true,
        content: Text("أعد تسجيل الدخول"),
        elevation: 10,
      ));
    } else {
      return result;
    }
  } on SocketException {
    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
      showCloseIcon: true,
      content: Text("لا يمكن الوصول للمخدم"),
      elevation: 10,
    ));
  } catch (e) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      showCloseIcon: true,
      content: Text("حدث خطأ \n $e"),
      elevation: 10,
    ));
  }
}

apiPost(
    {ctx,
    connectType = 'http',
    List<Map<int, Map<String, String?>>>? files,
    required String api,
    Map<String, String>? fields,
    Map<String?, String?>? optionalfields,
    List<Map<String, List<Map<String, int>>>>? fieldsArray,
    Map<String, dynamic>? params}) async {
  var request = http.MultipartRequest(
    "POST",
    connectType == 'http'
        ? Uri.http(serverIp, api, params)
        : Uri.https(serverIp, api, params),
  );

  request.headers.addAll({
    'Accept': 'application/json',
    'Content-Type': 'multipart/form-data',
  });
  if (UserLoginInfo.get(sharedPref: sharedPref) != null) {
    request.headers.addAll({
      'Authorization': 'Bearer ${UserLoginInfo.get(sharedPref: sharedPref)[4]}',
    });
  }

  if (fields != null) {
    request.fields.addAll(fields);
  }
  if (optionalfields != null) {
    for (var i in optionalfields.keys) {
      if (i != null) {
        request.fields.addAll({i: optionalfields[i]!});
      }
    }
  }

  if (files != null) {
    for (var e in files) {
      for (var i = 0; i < e.keys.first; i++) {
        try {
          request.files.add(await http.MultipartFile.fromPath(
            e.values.first.keys.first,
            e.values.first.values.first!,
          ));
        } catch (e) {}
      }
    }
  }

  if (fieldsArray != null) {
    int index = 1;
    for (var i in fieldsArray) {
      for (var m in i.entries) {
        for (var s in m.value) {
          for (var u in s.entries) {
            request.fields.addAll({"${m.key}[$index][${u.key}]": "${u.value}"});
          }
          index++;
        }
      }
    }
  }

  if (params != null) {
    request.fields['data'] = jsonEncode(params);
  }

  try {
    var response = await request.send();
    var responseData = await http.Response.fromStream(response);
    var result = jsonDecode(responseData.body);
    if (result != null && result['message'] == "Unauthenticated") {
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        showCloseIcon: true,
        content: Text("أعد تسجيل الدخول"),
        elevation: 10,
      ));
    } else {
      return result;
    }
  } on SocketException {
    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
      showCloseIcon: true,
      content: Text("لا يمكن الوصول للمخدم"),
      elevation: 10,
    ));
  } catch (e) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      showCloseIcon: true,
      content: Text("حدث خطأ \n $e"),
      elevation: 10,
    ));
  }
}

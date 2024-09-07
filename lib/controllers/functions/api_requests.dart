import 'dart:convert';
import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/controllers/static/server_info.dart';
import 'package:fit_medicine_02/controllers/static/userlogin_Info.dart';
import 'package:http/http.dart' as http;

apiGET(
    {connectType = 'http',
    required String api,
    Map<String, dynamic>? params,
    Map<String, String>? headers}) async {
  http.Response? resp;
  try {
    connectType == 'http'
        ? resp = await http.get(Uri.http(serverIp, api, params), headers: {
            'Accept': '*/*',
          }).timeout(Duration(seconds: 3))
        : resp = await http
            .get(Uri.https(serverIp, api, params), headers: {'Accept': '*/*'});
    return jsonDecode(resp.body);
  } catch (e) {
    return {"error": e};
  }
}

apiPost(
    {connectType = 'http',
    List<Map<int, Map<String, String?>>>? files,
    required String api,
    Map<String, String>? fields,
    List<Map<String, dynamic>>? medicines,
    List<Map<String, dynamic>>? feeds,
    Map<String, num>? fieldsNum,
    Map<String, dynamic>? params,
    Map<String, String>? headers}) async {
  var request = http.MultipartRequest(
    "POST",
    connectType == 'http'
        ? Uri.http(serverIp, api, params)
        : Uri.https(serverIp, api, params),
  );

  request.headers.addAll({
    'Accept': 'application/json',
  });
  if (UserLoginInfo.get(sharedPref: sharedPref) != null) {
    request.headers.addAll({
      'Authorization': 'Bearer ${UserLoginInfo.get(sharedPref: sharedPref)[4]}',
    });
  }

  if (fields != null) {
    request.fields.addAll(fields);
  }

  if (medicines != null) {
    request.fields['medicines'] = jsonEncode(medicines);
  }
  if (feeds != null) {
    request.fields['feeds'] = jsonEncode(feeds);
  }

  if (fieldsNum != null) {
    fieldsNum.forEach((key, value) {
      request.fields[key] = value.toString();
    });
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

  try {
    var response = await request.send();
    var responseData = await http.Response.fromStream(response);
    print(jsonDecode(responseData.body));
    return jsonDecode(responseData.body);
  } catch (e) {
    print(e);
    return {"message": e};
  }
}

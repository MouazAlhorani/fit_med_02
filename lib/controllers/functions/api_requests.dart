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
            'Accept': 'application/json',
          }).timeout(Duration(seconds: 3))
        : resp = await http.get(Uri.https(serverIp, api, params),
            headers: {'Accept': 'application/json'});
    print(jsonDecode(resp.body));
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
    List<Map<String, List>>? fieldsArray,
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

  request.fields.addAll({
    "medicines": jsonEncode([
      {"id": 1, "quantity": 2},
      {"id": 2, "quantity": 2}
    ]),
    "feeds": jsonEncode([
      {"id": 1, "quantity": 1}
    ])
  });
  print("this is ${fieldsArray}");
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

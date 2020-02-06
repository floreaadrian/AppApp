import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:sefii_flutter_x/Model/specialization_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SpecializationRepository {
  List<SpecializationSettings> data;

  final String baseUrl = "http://localhost:300/business/";
  Map<String, String> headers = {
    "Content-type": "application/x-www-form-urlencoded"
  };

  Future<List<SpecializationSettings>> getAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString("_id"));
    String urlToSend = baseUrl + prefs.getString("_id") + "/services";
    print(urlToSend);
    Response response = await get(
      urlToSend,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> body = jsonDecode(response.body)["result"];
      List<SpecializationSettings> newData = body
          .map(
            (f) => SpecializationSettings.fromJson(f),
          )
          .toList();
      data = newData;
    } else {
      print("Couldn't get specialization\n The reason" + response.body + "\n");
    }
    return data;
  }

  Future<void> addSpecialization(
      SpecializationSettings specializationSettings) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> toSend = specializationSettings.toJson();
    toSend["bussniesId"] = prefs.getString("_id");
    toSend["_id"] = "ce";
    headers[HttpHeaders.authorizationHeader] =
        "Basic " + prefs.getString('token');
    Response response = await post(
      baseUrl + "add",
      headers: headers,
      body: toSend,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      dynamic body = jsonDecode(response.body);
      print(body);
      return body;
    } else {
      print("Couldn't add the specialization\n The reason" +
          response.body +
          "\n");
      return "";
    }
  }
}

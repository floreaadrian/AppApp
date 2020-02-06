import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sefii_flutter_x/Model/business_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BussinesSettingsRepository {
  final String baseUrl = "http://localhost:300/business/";
  Map<String, String> headers = {
    "Content-type": "application/x-www-form-urlencoded"
  };

  var formatter = new DateFormat('yyyy-MM-dd');

  Future<BusinessInfo> getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String urlToSend = baseUrl + prefs.getString("_id") + "/details";
    Response response = await get(urlToSend);
    if (response.statusCode == 200 || response.statusCode == 201) {
      dynamic body = jsonDecode(response.body)["result"];
      return BusinessInfo.fromJson(body);
    } else {
      print("Couldn't get details\n The reason" + response.body + "\n");
      return null;
    }
  }

  Future<bool> changeSettings(
      int phone, String cartier, String category, String password) async {
    String phoneParsed = "";
    if (phone != null) {
      phoneParsed = phone.toString();
    }
    Map<String, String> toSend = {
      "password": phoneParsed ?? "",
      "cartier": cartier ?? "",
      "category": category ?? "",
      "phone": phoneParsed ?? "",
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String urlToSend = baseUrl + prefs.getString("_id") + "/settings";
    Response response = await put(urlToSend, body: toSend);
    print(toSend);
    if (response.statusCode == 200 || response.statusCode == 201) {
      //dynamic body = jsonDecode(response.body)["result"];
      return true;
    } else {
      print("Couldn't update settings\n The reason" + response.body + "\n");
      return false;
    }
  }
}

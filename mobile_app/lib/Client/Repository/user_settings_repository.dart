import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sefii_flutter_x/Model/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSettingsRepository {
  final String baseUrl = "http://localhost:300/client/";
  Map<String, String> headers = {
    "Content-type": "application/x-www-form-urlencoded"
  };

  var formatter = new DateFormat('yyyy-MM-dd');

  Future<UserInfo> getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String urlToSend = baseUrl + prefs.getString("_id") + "/details";
    Response response = await get(urlToSend);
    if (response.statusCode == 200 || response.statusCode == 201) {
      dynamic body = jsonDecode(response.body)["result"];
      print(body);
      return UserInfo.fromJson(body);
    } else {
      print("Couldn't get details\n The reason" + response.body + "\n");
      return null;
    }
  }

  Future<bool> changeSettings(DateTime dob, String password) async {
    String dobFormated = dob != null ? formatter.format(dob) : "";
    Map<String, String> toSend = {
      "dob": dobFormated,
      "password": password ?? ""
    };
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String urlToSend = baseUrl + prefs.getString("_id") + "/settings";
    Response response = await put(urlToSend, body: toSend);
    if (response.statusCode == 200 || response.statusCode == 201) {
      dynamic body = jsonDecode(response.body)["result"];
      print(body);
      return true;
    } else {
      print("Couldn't update settings\n The reason" + response.body + "\n");
      return false;
    }
  }
}

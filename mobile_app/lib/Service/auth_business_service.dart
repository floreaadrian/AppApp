import 'dart:convert';

import 'package:http/http.dart';
import 'package:sefii_flutter_x/Model/business_to_register.dart';
import 'package:sefii_flutter_x/Model/login_enum.dart';
import 'package:sefii_flutter_x/Model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBusinessService {
  final String baseUrl = "http://localhost:300/business/";
  Map<String, String> headers = {
    "Content-type": "application/x-www-form-urlencoded"
  };
  Future<String> signUp(
      BusinessToRegister businessToRegister, String password) async {
    Map<String, dynamic> toSend = businessToRegister.toJson();
    String urlToSend = baseUrl + "register";
    toSend["password"] = password;
    Response response = await post(
      urlToSend,
      headers: headers,
      body: toSend,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      dynamic body = jsonDecode(response.body);
      print(body);
      return "ok";
    } else {
      print("Couldn't sign up business\n The reason" + response.body + "\n");
      return "";
    }
  }

  Future<bool> checkPin(String token, String code) async {
    return true;
  }

  Future<LoginStatus> login(LoginModel loginModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> toSend = loginModel.toJson();
    Response response = await post(
      baseUrl + "login",
      headers: headers,
      body: toSend,
    );
    if (response.statusCode == 200) {
      dynamic body = jsonDecode(response.body);
      if (body["result"]["activated"] == true) {
        prefs.setString('token', body['token']);
        prefs.setString('type', "business");
        prefs.setString('_id', body['result']['id']);
        return LoginStatus.succes;
      } else {
        return LoginStatus.notActivated;
      }
    } else {
      return LoginStatus.fail;
    }
  }
}

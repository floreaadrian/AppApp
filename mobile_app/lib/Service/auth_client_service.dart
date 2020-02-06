import 'dart:convert';

import 'package:http/http.dart';
import 'package:sefii_flutter_x/Model/login_enum.dart';
import 'package:sefii_flutter_x/Model/login_model.dart';
import 'package:sefii_flutter_x/Model/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthClientService {
  final String baseUrl = "http://localhost:300/client/";
  Map<String, String> headers = {
    "Content-type": "application/x-www-form-urlencoded"
  };

  Future<String> signUp(UserInfo userInfo, String password) async {
    Map<String, dynamic> toSend = userInfo.toJson();
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
      print("Couldn't sign up user\n The reason" + response.body + "\n");
      return "";
    }
  }

  Future<bool> checkPin(String token, String code) async {
    return true;
  }

//fds 12
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
      print(body);
      if (body["result"]["activated"] == true) {
        prefs.setString('token', body['token']);
        prefs.setString('type', "user");
        prefs.setString('_id', body['result']['_id']);
        return LoginStatus.succes;
      } else
        return LoginStatus.notActivated;
    } else {
      return LoginStatus.fail;
    }
  }
}

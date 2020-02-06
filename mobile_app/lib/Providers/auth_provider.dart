import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sefii_flutter_x/Controller/auth_controller.dart';
import 'package:sefii_flutter_x/Model/business_to_register.dart';
import 'package:sefii_flutter_x/Model/login_enum.dart';
import 'package:sefii_flutter_x/Model/login_model.dart';
import 'package:sefii_flutter_x/Model/user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  AuthController authController = new AuthController();

  Future<LoginStatus> logInClient(LoginModel loginModel) async {
    LoginStatus result = await authController.logInClient(loginModel);
    return result;
  }

  Future<LoginStatus> logInBusiness(LoginModel loginModel) async {
    LoginStatus result = await authController.logInBusiness(loginModel);
    return result;
  }

  Future<bool> signUpClient(UserInfo userInfo, String password) async {
    String result = await authController.signUpClient(userInfo, password);
    print(result);
    if (result != null && result != "") {
      return true;
    }
    return false;
  }

  Future<bool> signUpBusiness(
      BusinessToRegister businessToRegister, String password) async {
    String result =
        await authController.signUpBusiness(businessToRegister, password);
    if (result != null && result != "") {
      return true;
    }
    return false;
  }

  Future<bool> sendCode(String token, String code, String userType) async {
    return authController.checkPin(token, code, userType);
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    return;
  }

  Future<List<String>> tokenInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String type = prefs.getString("type");
    print(prefs.getString("token"));
    if (type != null && type != "") {
      return [
        type,
        prefs.getString("token"),
      ];
    } else
      return null;
  }
}

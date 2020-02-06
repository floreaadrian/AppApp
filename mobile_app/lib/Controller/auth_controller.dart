import 'package:sefii_flutter_x/Model/business_to_register.dart';
import 'package:sefii_flutter_x/Model/login_enum.dart';
import 'package:sefii_flutter_x/Model/login_model.dart';
import 'package:sefii_flutter_x/Model/user_info.dart';
import 'package:sefii_flutter_x/Service/auth_business_service.dart';
import 'package:sefii_flutter_x/Service/auth_client_service.dart';

class AuthController {
  final AuthBusinessService authBusinessService = new AuthBusinessService();
  final AuthClientService authClientService = new AuthClientService();

  Future<String> signUpClient(UserInfo userInfo, String password) {
    return authClientService.signUp(userInfo, password);
  }

  Future<String> signUpBusiness(
      BusinessToRegister businessToRegister, String password) {
    return authBusinessService.signUp(businessToRegister, password);
  }

  Future<bool> checkPin(String token, String code, String userType) {
    if (userType == "user")
      return authClientService.checkPin(token, code);
    else
      return authBusinessService.checkPin(token, code);
  }

  Future<LoginStatus> logInClient(LoginModel loginModel) async {
    return authClientService.login(loginModel);
  }

  Future<LoginStatus> logInBusiness(LoginModel loginModel) async {
    return authBusinessService.login(loginModel);
  }
}

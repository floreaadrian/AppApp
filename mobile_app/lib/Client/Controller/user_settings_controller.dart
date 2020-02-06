import 'package:sefii_flutter_x/Client/Repository/user_settings_repository.dart';
import 'package:sefii_flutter_x/Model/user_info.dart';

class UserSettingsController {
  UserSettingsRepository repository = new UserSettingsRepository();

  Future<bool> changeSettings(DateTime dob, String password) async {
    return repository.changeSettings(dob, password);
  }

  Future<UserInfo> getDetails() async {
    return repository.getDetails();
  }
}

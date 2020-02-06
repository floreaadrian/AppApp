import 'package:sefii_flutter_x/Business/Repository/business_settings_repository.dart';
import 'package:sefii_flutter_x/Model/business_info.dart';

class BussinesSettingsController {
  BussinesSettingsRepository repository = new BussinesSettingsRepository();

  Future<bool> changeSettings(
      int phone, String cartier, String category, String password) async {
    return repository.changeSettings(phone, cartier, category, password);
  }

  Future<BusinessInfo> getDetails() async {
    return repository.getDetails();
  }
}

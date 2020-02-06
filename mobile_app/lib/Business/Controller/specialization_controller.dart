import 'package:sefii_flutter_x/Business/Repository/specialization_repository.dart';
import 'package:sefii_flutter_x/Model/specialization_settings.dart';

class SpecializationController {
  final SpecializationRepository repository;

  SpecializationController(this.repository);

  Future<List<SpecializationSettings>> getAll() async {
    return repository.getAll();
  }

  Future<void> addSpecialization(
      SpecializationSettings specializationSettings) async {
    return repository.addSpecialization(specializationSettings);
  }
}

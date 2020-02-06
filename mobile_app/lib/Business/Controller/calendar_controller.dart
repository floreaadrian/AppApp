import 'package:sefii_flutter_x/Business/Repository/calendar_repository.dart';
import 'package:sefii_flutter_x/Model/business_event.dart';
import 'package:sefii_flutter_x/Model/specialization_settings.dart';

class CalendarController {
  final CalendarRepository calendarRepository;

  CalendarController(this.calendarRepository);

  Future<List<BusinessEvent>> getAll(DateTime dateTime) async {
    return calendarRepository.getAll(dateTime);
  }

  Future<List<BusinessEvent>> getForTodaySpecialization(
      SpecializationSettings specialization) async {
    return calendarRepository.getForTodaySpecialization(specialization);
  }
}

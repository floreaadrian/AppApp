import 'package:sefii_flutter_x/Client/Repository/reservation_maker_repository.dart';
import 'package:sefii_flutter_x/Model/avalible_date.dart';
import 'package:sefii_flutter_x/Model/specialization_settings.dart';

class ReservationMakerController {
  ReservationMakerRepository repository = new ReservationMakerRepository();
  List<AvalibleHour> cached;
  Future<bool> confirmReservation(
    SpecializationSettings specialization,
    AvalibleHour avalibleHour,
    DateTime date,
  ) {
    return repository.confirmReservation(specialization, avalibleHour, date);
  }

  Future<List<AvalibleHour>> getDates(
      DateTime date, SpecializationSettings specialization) async {
    if (cached == null)
      cached = await repository.getDates(date, specialization);
    return cached;
  }

  Future<List<AvalibleHour>> getNewDates(
      DateTime date, SpecializationSettings specialization) async {
    cached = await repository.getDates(date, specialization);
    return cached;
  }
}

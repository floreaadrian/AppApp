import 'package:sefii_flutter_x/Client/Repository/reservation_list_repository.dart';
import 'package:sefii_flutter_x/Model/reservation.dart';

class ReservationListController {
  ReservationListRepository repository = new ReservationListRepository();

  Future<bool> deleteReservation(Reservation reservation) async {
    return repository.deleteReservation(reservation);
  }

  Future<List<Reservation>> getReservation() async {
    return repository.getReservation();
  }
}

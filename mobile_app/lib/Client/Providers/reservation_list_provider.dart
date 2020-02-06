import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sefii_flutter_x/Client/Controller/reservation_list_controller.dart';
import 'package:sefii_flutter_x/Model/reservation.dart';

class ReservationListProvider extends ChangeNotifier {
  ReservationListController controller = new ReservationListController();

  void refresh() {
    notifyListeners();
  }

  Future<bool> deleteReservation(Reservation reservation) {
    return controller.deleteReservation(reservation);
  }

  Future<List<Reservation>> getData() async {
    List<Reservation> data = await controller.getReservation();
    return data;
  }
}

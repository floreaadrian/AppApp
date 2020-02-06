import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sefii_flutter_x/Client/Controller/reservation_maker_controller.dart';
import 'package:sefii_flutter_x/Model/avalible_date.dart';
import 'package:sefii_flutter_x/Model/specialization_settings.dart';

class ReservationMakerProvider extends ChangeNotifier {
  DateTime selectedDate;
  SpecializationSettings selectedSpecialization;
  bool needsToUpdate;
  ReservationMakerController controller = new ReservationMakerController();

  changeDate(DateTime date) {
    selectedDate = date;
    needsToUpdate = true;
    notifyListeners();
  }

  initProvider(SpecializationSettings specialization, DateTime date) {
    selectedDate = date;
    selectedSpecialization = specialization;
    needsToUpdate = true;
  }

  Future<bool> confirmReservation(AvalibleHour selectedHour) async {
    bool result = await controller.confirmReservation(
        selectedSpecialization, selectedHour, selectedDate);
    return result;
  }

  Future<List<AvalibleHour>> getData() async {
    List<AvalibleHour> data;
    if (needsToUpdate) {
      data = await controller.getNewDates(selectedDate, selectedSpecialization);
      needsToUpdate = false;
    } else
      data = await controller.getDates(selectedDate, selectedSpecialization);
    return data;
  }
}

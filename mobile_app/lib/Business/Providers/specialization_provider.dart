import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sefii_flutter_x/Business/Controller/specialization_controller.dart';
import 'package:sefii_flutter_x/Business/Repository/specialization_repository.dart';
import 'package:sefii_flutter_x/Model/avalible_date.dart';
import 'package:sefii_flutter_x/Model/specialization_settings.dart';

class SpecializationProvider extends ChangeNotifier {
  SpecializationController controller =
      new SpecializationController(new SpecializationRepository());

  void refresh() {
    notifyListeners();
  }

  Future<void> addSpecialization({
    String nume,
    String descriere,
    TimeOfDay startHour,
    TimeOfDay endHour,
    int timpRezervare,
    List<String> zileSelectate,
  }) async {
    ///TODO: verifica daca is nulle si faci si return true/false
    SpecializationSettings specializationSettings = new SpecializationSettings(
      bussniesId: "fs",
      name: nume ?? "",
      desc: descriere ?? "",
      avalibleHour: AvalibleHour(
        startHour: startHour.hour ?? 0,
        startMinute: startHour.minute ?? 0,
        endHour: endHour.hour ?? 23,
        endMinute: endHour.minute ?? 59,
      ),
      duration: timpRezervare ?? 10,
      zile: zileSelectate,
    );
    await controller.addSpecialization(specializationSettings);
    notifyListeners();
    return;
  }

  Future<List<SpecializationSettings>> getData() async {
    List<SpecializationSettings> data = await controller.getAll();
    return data;
  }
}

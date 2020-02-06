import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sefii_flutter_x/Model/business_event.dart';
import 'package:sefii_flutter_x/Model/specialization_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CalendarRepository {
  var formatter = new DateFormat('yyyy-MM-dd');

  final List<BusinessEvent> businessEvent = [];

  final String baseUrl = "http://localhost:300/reservation/";

  Future<List<BusinessEvent>> getAll(DateTime dateTime) async {
    String now = formatter.format(dateTime);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String urlToSend =
        baseUrl + "business/" + prefs.getString("_id") + "?date=" + now;
    Response response = await get(
      urlToSend,
    );
    List<BusinessEvent> data = [];
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> body = jsonDecode(response.body)["result"];
      data = body
          .map(
            (f) => BusinessEvent.fromJson(f),
          )
          .toList();
    } else {
      print("Couldn't find business dates\n The reason" + response.body + "\n");
    }
    return data;
  }

  Future<List<BusinessEvent>> getForTodaySpecialization(
      SpecializationSettings specialization) async {
    String now = formatter.format(DateTime.now());
    String urlToSend =
        baseUrl + "service/" + specialization.specializationId + "?date=" + now;
    Response response = await get(
      urlToSend,
    );
    List<BusinessEvent> data = [];
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> body = jsonDecode(response.body)["result"];
      data = body
          .map(
            (f) => BusinessEvent.fromJson(f),
          )
          .toList();
    } else {
      print("Couldn't found specializations dates\n The reason" +
          response.body +
          "\n");
    }
    return data;
  }
}

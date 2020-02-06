import 'dart:convert';

import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:sefii_flutter_x/Model/avalible_date.dart';
import 'package:sefii_flutter_x/Model/specialization_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationMakerRepository {
  var formatter = new DateFormat('yyyy-MM-dd');
  final String baseUrl = "http://localhost:300/";
  Map<String, String> headers = {
    "Content-type": "application/x-www-form-urlencoded"
  };

  List<AvalibleHour> avalible = [];

  Future<bool> confirmReservation(SpecializationSettings specialization,
      AvalibleHour avalibleHour, DateTime dateTime) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String urlToSend = baseUrl + "reservation/add";
    Map<String, String> toSend = {
      "businessId": specialization.bussniesId,
      "specializationId": specialization.specializationId,
      "startTime": avalibleHour.startHour.toString() +
          ":" +
          avalibleHour.startMinute.toString(),
      "endTime": avalibleHour.endHour.toString() +
          ":" +
          avalibleHour.endMinute.toString(),
      "date": formatter.format(dateTime),
      "clientId": prefs.getString("_id"),
    };
    Response response = await post(urlToSend, headers: headers, body: toSend);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print("Couldn't make reservation\n The reason" + response.body + "\n");
      return false;
    }
  }

  List<AvalibleHour> bubbleSort(List<AvalibleHour> list) {
    for (int i = 0; i < list.length; i++) {
      for (int j = 0; j < list.length - 1; j++) {
        int firstTime = list[j].startHour * 60 + list[j].startMinute;
        int secondTime = list[j + 1].startHour * 60 + list[j + 1].startMinute;
        if (firstTime > secondTime) {
          AvalibleHour num = list[j];
          list[j] = list[j + 1];
          list[j + 1] = num;
        }
      }
    }
    return list;
  }

  Future<List<AvalibleHour>> getDates(
      DateTime dateTime, SpecializationSettings specialization) async {
    String urlToSend = baseUrl +
        "business/" +
        specialization.specializationId +
        "/datesAvalible?date=" +
        formatter.format(dateTime);
    Response response = await get(
      urlToSend,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> body = jsonDecode(response.body)["result"];
      print(body);
      List<AvalibleHour> newData = body
          .map(
            (f) => AvalibleHour.fromJson(f),
          )
          .toList();
      avalible = newData;
    } else {
      print("Couldn't get dates\n The reason" + response.body + "\n");
    }
    avalible = bubbleSort(avalible);
    return avalible;
  }
}

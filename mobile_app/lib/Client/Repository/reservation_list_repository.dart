import 'dart:convert';

import 'package:http/http.dart';
import 'package:sefii_flutter_x/Model/reservation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservationListRepository {
  List<Reservation> data = [];
  final String baseUrl = "http://localhost:300/reservation/client/";
  Map<String, String> headers = {
    "Content-type": "application/x-www-form-urlencoded"
  };

  Future<bool> deleteReservation(Reservation reservation) async {
    Response response =
        await delete("http://localhost:300/reservation/" + reservation.id);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
    return false;
  }

  Future<List<Reservation>> getReservation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String urlToSend = baseUrl + prefs.getString("_id");
    Response response = await get(
      urlToSend,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> body = jsonDecode(response.body)["result"];
      List<Reservation> newData = body
          .map(
            (f) => Reservation.fromJson(f),
          )
          .toList();
      data = newData;
    } else {
      print("Couldn't sign up business\n The reason" + response.body + "\n");
    }
    return data;
  }
}

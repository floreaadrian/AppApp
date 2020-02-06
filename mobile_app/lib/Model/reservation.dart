import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'avalible_date.dart';
import 'business_info.dart';

var formatter = new DateFormat('yyyy-MM-dd');

class Reservation {
  final String id;
  final BusinessInfo business;
  final String specializaton;
  final AvalibleHour avalibleHour;
  final DateTime dateTime;

  Reservation({
    @required this.id,
    @required this.business,
    @required this.specializaton,
    @required this.avalibleHour,
    @required this.dateTime,
  });

  Reservation.fromJson(Map<String, dynamic> json)
      : dateTime = DateTime.parse(json['date']),
        avalibleHour = new AvalibleHour(
            startHour: int.parse(json['startTime'].toString().split(":")[0]),
            startMinute: int.parse(json['startTime'].toString().split(":")[1]),
            endHour: int.parse(json['endTime'].toString().split(":")[0]),
            endMinute: int.parse(json['endTime'].toString().split(":")[1])),
        business = BusinessInfo.fromJson(json['business']),
        id = json["_id"],
        specializaton = json['specializaton'];

  Map<String, dynamic> toJson() => {
        'date': formatter.format(dateTime ?? DateTime.now()),
        'businessId': business.id,
        'startTime': avalibleHour.startHour.toString() +
            ":" +
            avalibleHour.startMinute.toString(),
        'endTime': avalibleHour.endHour.toString() +
            ":" +
            avalibleHour.endMinute.toString(),
      };
}

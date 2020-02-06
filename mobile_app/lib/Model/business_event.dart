import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sefii_flutter_x/Model/avalible_date.dart';

var formatter = new DateFormat('yyyy-MM-dd');

class BusinessEvent {
  final String userName;
  final AvalibleHour avalibleHour;
  final DateTime dateTime;
  final String specializationName;

  BusinessEvent({
    @required this.userName,
    @required this.avalibleHour,
    @required this.dateTime,
    @required this.specializationName,
  });

  BusinessEvent.fromJson(Map<String, dynamic> json)
      : dateTime = DateTime.parse(json['date']),
        avalibleHour = new AvalibleHour(
            startHour: int.parse(json['startTime'].toString().split(":")[0]),
            startMinute: int.parse(json['startTime'].toString().split(":")[1]),
            endHour: int.parse(json['endTime'].toString().split(":")[0]),
            endMinute: int.parse(json['endTime'].toString().split(":")[1])),
        userName = json['userName'],
        specializationName = json['specializatonName'];

  Map<String, dynamic> toJson() => {
        'date': formatter.format(dateTime ?? DateTime.now()),
        'userName': userName,
        'startTime': avalibleHour.startHour.toString() +
            ":" +
            avalibleHour.startMinute.toString(),
        'endTime': avalibleHour.endHour.toString() +
            ":" +
            avalibleHour.endMinute.toString(),
        'specializatonName': specializationName
      };
}

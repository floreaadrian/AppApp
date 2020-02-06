import 'package:flutter/material.dart';

class AvalibleHour {
  final int startHour;
  final int startMinute;
  final int endHour;
  final int endMinute;

  AvalibleHour({
    @required this.startHour,
    @required this.startMinute,
    this.endHour,
    this.endMinute,
  });

  AvalibleHour.fromJson(Map<String, dynamic> json)
      : startHour = int.parse(json['startTime'].toString().split(":")[0]),
        startMinute = int.parse(json['startTime'].toString().split(":")[1]),
        endHour = int.parse(json['endTime'].toString().split(":")[0]),
        endMinute = int.parse(json['endTime'].toString().split(":")[1]);

  Map<String, dynamic> toJson() => {
        'startTime': startHour.toString() + ":" + startMinute.toString(),
        'endTime': endHour.toString() + ":" + endMinute.toString(),
      };
}

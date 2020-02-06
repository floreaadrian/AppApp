import 'package:flutter/material.dart';
import 'package:sefii_flutter_x/Model/avalible_date.dart';

class SpecializationSettings {
  final String specializationId;
  final String bussniesId;
  final String name;
  final String desc;
  final AvalibleHour avalibleHour;
  final int duration;
  final List<String> zile;

  SpecializationSettings({
    this.specializationId,
    @required this.bussniesId,
    @required this.name,
    @required this.desc,
    @required this.avalibleHour,
    @required this.duration,
    @required this.zile,
  });

  SpecializationSettings.fromJson(Map<String, dynamic> json)
      : specializationId = json['_id'],
        bussniesId = json['bussniesId'],
        name = json['name'],
        desc = json['desc'],
        avalibleHour = new AvalibleHour(
            startHour: int.parse(json['startTime'].toString().split(":")[0]),
            startMinute: int.parse(json['startTime'].toString().split(":")[1]),
            endHour: int.parse(json['endTime'].toString().split(":")[0]),
            endMinute: int.parse(json['endTime'].toString().split(":")[1])),
        duration = json['duration'],
        zile = json['zile'].toString().split(',').toList();

  Map<String, dynamic> toJson() => {
        '_id': specializationId,
        'bussniesId': bussniesId,
        'name': name,
        'desc': desc,
        'duration': duration.toString(),
        'zile': zile.join(","),
        'startTime': avalibleHour.startHour.toString() +
            ":" +
            avalibleHour.startMinute.toString(),
        'endTime': avalibleHour.endHour.toString() +
            ":" +
            avalibleHour.endMinute.toString()
      };
}

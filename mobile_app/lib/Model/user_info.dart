import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

var formatter = new DateFormat('yyyy-MM-dd');

class UserInfo {
  final String name;
  final String email;
  final String username;
  final int phone;
  final DateTime dob;

  UserInfo({
    this.username,
    this.phone,
    @required this.name,
    @required this.email,
    this.dob,
  });

  UserInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        username = json['username'],
        phone = json['phone'],
        dob = DateTime.parse(json['dob']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone.toString(),
        'dob': formatter.format(dob ?? DateTime.now()),
        'username': username
      };
}

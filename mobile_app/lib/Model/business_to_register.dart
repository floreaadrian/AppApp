import 'package:flutter/foundation.dart';

class BusinessToRegister {
  final String title;
  final String adress;
  final String desc;
  final int phone;
  final String email;

  BusinessToRegister({
    @required this.title,
    @required this.adress,
    @required this.desc,
    @required this.phone,
    @required this.email,
  });

  BusinessToRegister.fromJson(Map<String, dynamic> json)
      : title = json['name'],
        email = json['email'],
        desc = json['username'],
        phone = json['phone'],
        adress = json['adress'];

  Map<String, dynamic> toJson() => {
        'name': title,
        'email': email,
        'phone': phone.toString(),
        'desc': desc,
        'adress': adress,
      };
}

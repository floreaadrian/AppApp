import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusinessInfo {
  final String id;
  final String title;
  final String adress;
  final String desc;
  final int phoneNumber;
  final String email;
  final LatLng latLng;
  final String category;
  final String cartier;

  BusinessInfo({
    @required this.category,
    @required this.cartier,
    @required this.latLng,
    @required this.email,
    @required this.id,
    @required this.title,
    @required this.adress,
    @required this.desc,
    @required this.phoneNumber,
  });

  BusinessInfo.fromJson(Map<String, dynamic> json)
      : title = json['name'],
        email = json['email'],
        phoneNumber = json['phone'],
        desc = json['desc'],
        adress = json['adress'],
        category = json['category'],
        cartier = json['cartier'],
        id = json['id'],
        latLng = new LatLng(
            double.parse(json['latLang'].toString().split(',')[0]),
            double.parse(json['latLang'].toString().split(',')[1]));

  Map<String, dynamic> toJson() => {
        'cartier': cartier,
        'category': category,
        'name': title,
        'email': email,
        'phone': phoneNumber,
        '_id': id,
        'adress': adress,
        'latLng':
            latLng.latitude.toString() + "," + latLng.longitude.toString(),
        'desc': desc
      };
}

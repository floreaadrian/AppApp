import 'package:flutter/material.dart';

class LoginModel {
  final String email;
  final String password;

  LoginModel({
    @required this.email,
    @required this.password,
  });

  LoginModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
      };
}

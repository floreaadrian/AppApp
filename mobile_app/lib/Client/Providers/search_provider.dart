import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:sefii_flutter_x/Model/business_info.dart';

class SearchProvider extends ChangeNotifier {
  String category_selected = "";
  String cartier_selected = "";
  String name_to_search = "";
  List<BusinessInfo> data = [];
  final String baseUrl = "http://localhost:300/businesses/";
  Map<String, String> headers = {
    "Content-type": "application/x-www-form-urlencoded"
  };

  changeCategory(String category) async {
    category_selected = category;
    await search();
  }

  changeCartier(String cartier) async {
    cartier_selected = cartier;
    await search();
  }

  changeName(String name) async {
    name_to_search = name;
    await search();
  }

  search() async {
    String urlToSend = baseUrl +
        "?cartier=" +
        cartier_selected +
        "&categorie=" +
        category_selected +
        "&nume=" +
        name_to_search;
    Response response = await get(
      urlToSend,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> body = jsonDecode(response.body)["result"];
      print(body);
      List<BusinessInfo> newData = body
          .map(
            (f) => BusinessInfo.fromJson(f),
          )
          .toList();
      data = newData;
    } else {
      data = [];
      print("Couldn't sign up business\n The reason" + response.body + "\n");
    }
    notifyListeners();
  }

  Future<List<BusinessInfo>> getData() async {
    if (cartier_selected == "" &&
        category_selected == "" &&
        name_to_search == "") data = [];
    return data;
  }
}

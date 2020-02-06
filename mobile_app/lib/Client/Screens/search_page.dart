import 'package:flutter/material.dart';
import 'package:sefii_flutter_x/Client/Widgets/dropdown_cartier.dart';
import 'package:sefii_flutter_x/Client/Widgets/dropdown_category.dart';
import 'package:sefii_flutter_x/Client/Widgets/handmade_searchbar.dart';
import 'package:sefii_flutter_x/Client/Widgets/user_drawer.dart';
import 'package:sefii_flutter_x/Model/user_info.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cauta o firma"),
      ),
      drawer: UserDrawer(
        userInfo: UserInfo(
          email: "ok@yahoo.com",
          name: "ok",
        ),
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              DropDownCartier(),
              DropDownCategory(),
              HandMadeSearchBar(),
            ],
          ),
        ),
      ),
    );
  }
}

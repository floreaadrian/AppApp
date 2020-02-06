import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:sefii_flutter_x/Client/Widgets/toolbar.dart';
import 'package:sefii_flutter_x/Model/specialization_settings.dart';
import 'package:sefii_flutter_x/route.dart';

import '../text_style.dart';

class SpecializationSelectPage extends StatelessWidget {
  final String bussinesId;
  const SpecializationSelectPage({
    Key key,
    this.bussinesId,
  }) : super(key: key);

  Container _specializationWidget(
      BuildContext context, SpecializationSettings specialization) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            MAKE_RESERVATION_PAGE_ROUTE,
            arguments: specialization,
          );
        },
        child: Card(
          elevation: 8.0,
          color: Theme.of(context).primaryColor,
          margin: new EdgeInsets.symmetric(vertical: 10.0),
          child: ListTile(
            contentPadding:
                EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
            leading: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                border: new Border(
                  right: new BorderSide(
                    width: 1.0,
                    color: Colors.white24,
                  ),
                ),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  FontAwesomeIcons.wrench,
                  color: Theme.of(context).backgroundColor,
                ),
              ),
            ),
            title: Text(
              specialization.name,
              style: Style.titleTextStyle,
            ),
            subtitle: Text(
              specialization.desc,
              style: Style.baseTextStyle,
            ),
            trailing: Icon(
              Icons.keyboard_arrow_right,
              color: Colors.white,
              size: 30.0,
            ),
          ),
        ),
      ),
    );
  }

  Future<List<SpecializationSettings>> getSpecializations() async {
    String urlToSend =
        "http://localhost:300/business/" + bussinesId + "/services";
    Response response = await get(
      urlToSend,
    );
    List<SpecializationSettings> data = [];
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> body = jsonDecode(response.body)["result"];
      data = body
          .map(
            (f) => SpecializationSettings.fromJson(f),
          )
          .toList();
    } else {
      print("Couldn't get specialization\n The reason" + response.body + "\n");
    }
    return data;
  }

  Widget makeSpecializations(BuildContext context) {
    return FutureBuilder(
      future: getSpecializations(),
      builder: (context, avalibleDataSnap) {
        if (avalibleDataSnap.connectionState == ConnectionState.done) {
          if (avalibleDataSnap.data == null) return Container();
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(bottom: 30),
            itemCount: avalibleDataSnap.data.length,
            itemBuilder: (context, index) {
              return _specializationWidget(
                context,
                avalibleDataSnap.data[index],
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: new Stack(
          children: <Widget>[
            Container(
              margin: new EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 40,
              ),
              child: makeSpecializations(context),
            ),
            getToolbar(context)
          ],
        ),
      ),
    );
  }
}

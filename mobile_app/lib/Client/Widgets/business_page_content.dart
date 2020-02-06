import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sefii_flutter_x/Client/Widgets/business_map.dart';
import 'package:sefii_flutter_x/Client/Widgets/separator.dart';
import 'package:sefii_flutter_x/Model/business_info.dart';
import 'package:sefii_flutter_x/route.dart';

import '../text_style.dart';

class BusinessPageContent extends StatelessWidget {
  final BusinessInfo businessInfo;

  const BusinessPageContent({Key key, this.businessInfo}) : super(key: key);

  Container _overview(BuildContext context) {
    final _overviewTitle = "Overview".toUpperCase();
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            _overviewTitle,
            style: Style.headerTextStyle,
          ),
          new Separator(),
          new Text(
            businessInfo.desc,
            style: Style.commonTextStyle,
          ),
        ],
      ),
    );
  }

  Container _reserveButton(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            SPECIALIZATION_SELECT_PAGE_ROUTE,
            arguments: businessInfo.id,
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
                  FontAwesomeIcons.ticketAlt,
                  color: Theme.of(context).backgroundColor,
                ),
              ),
            ),
            title: Text(
              "Rezerva acum!",
              style: Style.headerTextStyle,
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

  Container _map(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10.0),
      height: 300,
      child: BusinessMap(
        businessInfo: businessInfo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: new EdgeInsets.symmetric(horizontal: 32.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _reserveButton(context),
          _map(context),
          _overview(context),
        ],
      ),
    );
  }
}

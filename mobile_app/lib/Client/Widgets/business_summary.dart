import 'package:flutter/material.dart';
import 'package:sefii_flutter_x/Client/Screens/business_info_page.dart';
import 'package:sefii_flutter_x/Client/Widgets/separator.dart';
import 'package:sefii_flutter_x/Model/business_info.dart';

import '../text_style.dart';

class BusinessSummary extends StatelessWidget {
  BusinessSummary({this.horizontal = true, this.businessInfo});

  BusinessSummary.vertical(this.businessInfo) : horizontal = false;

  final BusinessInfo businessInfo;
  final bool horizontal;

  @override
  Widget build(BuildContext context) {
    final planetThumbnail = new Container(
      margin: new EdgeInsets.symmetric(vertical: 16.0),
      alignment:
          horizontal ? FractionalOffset.centerLeft : FractionalOffset.center,
      child: new Hero(
        tag: "planet-hero-${businessInfo.id}",
        child: Text(businessInfo.title[0]),
      ),
    );

    Widget _planetValue({String value, IconData icon}) {
      return new Container(
        child: new Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          new Icon(icon, size: 8),
          new Container(width: 8.0),
          new Text(
            businessInfo.phoneNumber.toString(),
            style: Style.smallTextStyle,
          ),
        ]),
      );
    }

    final planetCardContent = new Container(
      margin: new EdgeInsets.fromLTRB(
        horizontal ? 76.0 : 16.0,
        horizontal ? 16.0 : 42.0,
        16.0,
        16.0,
      ),
      // constraints: new BoxConstraints.expand(),
      child: new Column(
        crossAxisAlignment:
            horizontal ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          new Container(height: 4.0),
          new Text(businessInfo.title, style: Style.titleTextStyle),
          new Container(height: 8.0),
          new Text(businessInfo.adress, style: Style.commonTextStyle),
          new Separator(),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                  flex: horizontal ? 1 : 0,
                  child: _planetValue(
                    value: businessInfo.phoneNumber.toString(),
                    icon: Icons.phone,
                  )),
              new Container(
                width: 32.0,
              ),
              new Expanded(
                  flex: horizontal ? 1 : 0,
                  child: _planetValue(
                    value: businessInfo.email,
                    icon: Icons.email,
                  ))
            ],
          ),
        ],
      ),
    );

    final planetCard = new Container(
      child: planetCardContent,
      // height: horizontal ? 200.0 : 220.0,
      margin: horizontal
          ? new EdgeInsets.only(left: 46.0)
          : new EdgeInsets.only(top: 72.0),
      decoration: new BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.rectangle,
        borderRadius: new BorderRadius.circular(8.0),
        boxShadow: <BoxShadow>[
          new BoxShadow(
            color: Colors.black12,
            blurRadius: 10.0,
            offset: new Offset(0.0, 10.0),
          ),
        ],
      ),
    );

    return new GestureDetector(
      onTap: horizontal
          ? () => Navigator.of(context).push(
                new PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new BusinessInfoPage(
                    businessInfo: businessInfo,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          new FadeTransition(opacity: animation, child: child),
                ),
              )
          : null,
      child: new Container(
        margin: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 24.0,
        ),
        child: new Stack(
          children: <Widget>[
            planetCard,
            planetThumbnail,
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sefii_flutter_x/Model/business_info.dart';
import 'package:sefii_flutter_x/route.dart';

class FirmaListWidget extends StatelessWidget {
  final BusinessInfo businessInfo;

  const FirmaListWidget({
    Key key,
    @required this.businessInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          BUSINESS_USER_INFO_ROUTE,
          arguments: businessInfo,
        );
      },
      child: Card(
        elevation: 8.0,
        color: Theme.of(context).cardColor,
        margin: new EdgeInsets.symmetric(vertical: 6.0),
        child: Container(
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
              child: new Hero(
                tag: "planet-hero-${businessInfo.id}",
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Text(businessInfo.title[0]),
                ),
              ),
            ),
            title: Text(
              businessInfo.title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
            subtitle: Text(businessInfo.adress),
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
}

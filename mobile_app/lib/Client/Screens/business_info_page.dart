import 'package:flutter/material.dart';
import 'package:sefii_flutter_x/Client/Widgets/business_page_content.dart';
import 'package:sefii_flutter_x/Client/Widgets/business_summary.dart';
import 'package:sefii_flutter_x/Client/Widgets/toolbar.dart';
import 'package:sefii_flutter_x/Model/business_info.dart';

class BusinessInfoPage extends StatelessWidget {
  final BusinessInfo businessInfo;

  const BusinessInfoPage({
    Key key,
    this.businessInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Container(
        constraints: new BoxConstraints.expand(),
        color: Theme.of(context).accentColor,
        child: new Stack(
          children: <Widget>[
            _getBackground(context),
            _getGradient(context),
            _getContent(),
            getToolbar(context),
          ],
        ),
      ),
    );
  }

  Container _getBackground(BuildContext context) {
    return new Container(
      color: Theme.of(context).cardColor,
      constraints: new BoxConstraints.expand(height: 295.0),
    );
  }

  Container _getGradient(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(top: 190.0),
      height: 110.0,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: <Color>[
            Theme.of(context).cardColor,
            Theme.of(context).accentColor
          ],
          stops: [0.0, 0.9],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(0.0, 1.0),
        ),
      ),
    );
  }

  Container _getContent() {
    return new Container(
      child: new ListView(
        padding: new EdgeInsets.fromLTRB(0.0, 72.0, 0.0, 32.0),
        children: <Widget>[
          new BusinessSummary(
            businessInfo: businessInfo,
            horizontal: false,
          ),
          BusinessPageContent(businessInfo: businessInfo)
        ],
      ),
    );
  }
}

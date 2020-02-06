import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sefii_flutter_x/route.dart';

class ChooseUserType extends StatelessWidget {
  const ChooseUserType({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
        color: theme.backgroundColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  new Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new MaterialButton(
                        color: theme.cardColor,
                        child: new Column(
                          children: <Widget>[
                            new Expanded(
                              flex: 4,
                              child: new LayoutBuilder(
                                  builder: (context, constraint) {
                                return new Icon(
                                  FontAwesomeIcons.building,
                                  color: theme.backgroundColor,
                                  size: constraint.biggest.height - 50,
                                );
                              }),
                            ),
                            new Expanded(child: new LayoutBuilder(
                                builder: (context, constraint) {
                              return new Text('BUSINESS',
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .apply(
                                          color: theme.backgroundColor,
                                          fontSizeFactor:
                                              constraint.biggest.height /
                                                  30.0));
                            })),
                          ],
                        ),
                        onPressed: () => Navigator.pushNamed(
                            context, LOG_IN_BUSINESS_ROUTE)),
                  )),
                  new Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new MaterialButton(
                        color: theme.cardColor,
                        child: new Column(
                          children: <Widget>[
                            new Expanded(
                              flex: 4,
                              child: new LayoutBuilder(
                                  builder: (context, constraint) {
                                return new Icon(
                                  FontAwesomeIcons.user,
                                  color: theme.backgroundColor,
                                  size: constraint.biggest.height - 50,
                                );
                              }),
                            ),
                            new Expanded(child: new LayoutBuilder(
                                builder: (context, constraint) {
                              return new Text('CLIENT',
                                  style: DefaultTextStyle.of(context)
                                      .style
                                      .apply(
                                          color: theme.backgroundColor,
                                          fontSizeFactor:
                                              constraint.biggest.height /
                                                  30.0));
                            })),
                          ],
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, LOG_IN_CLIENT_ROUTE)),
                  )),
                ]),
          ),
        ));
  }
}

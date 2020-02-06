import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgotPassword extends StatelessWidget {
  final String type;

  const ForgotPassword({Key key, this.type}) : super(key: key);

  Widget _buildPageContent(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      color: theme.backgroundColor,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _buildLoginForm(context),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                FloatingActionButton(
                  mini: true,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  backgroundColor: theme.cardColor,
                  child: Icon(Icons.arrow_back),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container _buildLoginForm(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: RoundedDiagonalPathClipper(),
            child: Container(
              height: 400,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 90.0,
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        style: TextStyle(
                          color: theme.primaryColor,
                        ),
                        decoration: InputDecoration(
                            hintText: "Email address",
                            hintStyle: TextStyle(
                              color: theme.splashColor,
                            ),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.email,
                              color: theme.splashColor,
                            )),
                      )),
                  Container(
                    child: Divider(
                      color: theme.accentColor,
                    ),
                    padding: EdgeInsets.only(
                      left: 20.0,
                      right: 20.0,
                      bottom: 10.0,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: 40.0,
                backgroundColor: theme.primaryColor,
                child: Icon(
                  FontAwesomeIcons.building,
                ),
              ),
            ],
          ),
          Container(
            height: 420,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Text(
                  "Send link",
                  style: TextStyle(color: theme.backgroundColor),
                ),
                color: theme.cardColor,
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageContent(context),
    );
  }
}

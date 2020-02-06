import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sefii_flutter_x/Model/login_enum.dart';
import 'package:sefii_flutter_x/Model/login_model.dart';
import 'package:sefii_flutter_x/Providers/auth_provider.dart';
import 'package:sefii_flutter_x/route.dart';

class LogInBusiness extends StatefulWidget {
  @override
  _LogInBusinessState createState() => _LogInBusinessState();
}

class _LogInBusinessState extends State<LogInBusiness> {
  String email = "";
  String password = "";

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, SIGN_IN_BUSINESS_ROUTE);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0),
                  ),
                  child: Text(
                    "Inregistrare",
                    style: TextStyle(color: theme.backgroundColor),
                  ),
                  color: theme.buttonColor,
                ),
              ],
            ),
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
                            hintText: "Adresa email",
                            hintStyle: TextStyle(
                              color: theme.splashColor,
                            ),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.email,
                              color: theme.splashColor,
                            )),
                        onChanged: (value) => email = value,
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      style: TextStyle(
                        color: theme.primaryColor,
                      ),
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Parola",
                        hintStyle: TextStyle(
                          color: theme.splashColor,
                        ),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.lock,
                          color: theme.splashColor,
                        ),
                      ),
                      onChanged: (value) => password = value,
                    ),
                  ),
                  Container(
                    child: Divider(
                      color: theme.accentColor,
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
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
                onPressed: () async {
                  final provider =
                      Provider.of<AuthProvider>(context, listen: false);
                  LoginModel loginModel = new LoginModel(
                    email: email,
                    password: password,
                  );
                  if (email == "" || password == "") {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.ERROR,
                      animType: AnimType.BOTTOMSLIDE,
                      tittle: 'Invalid',
                      desc: 'Campurile sunt goale',
                      btnCancelOnPress: () {},
                      btnCancelText: "Ok",
                    ).show();
                  } else {
                    LoginStatus flag = await provider.logInBusiness(loginModel);
                    if (flag == LoginStatus.succes) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        BUSINESS_CALENDAR_PAGE_ROUTE,
                        (Route<dynamic> route) => false,
                      );
                    } else if (flag == LoginStatus.fail) {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.ERROR,
                        animType: AnimType.BOTTOMSLIDE,
                        tittle: 'Eroare',
                        desc:
                            "Credentiale invalide\nTe rugam sa incerci din nou",
                        btnCancelOnPress: () {},
                        btnCancelText: "Ok",
                      ).show();
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.ERROR,
                        animType: AnimType.BOTTOMSLIDE,
                        tittle: 'Neactivat',
                        desc:
                            "Cont neactivat!\nTe rugam sa iti activezi contul pentru a continua\n",
                        btnCancelOnPress: () {},
                        btnCancelText: "Ok",
                      ).show();
                    }
                  }
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40.0),
                ),
                child: Text(
                  "Logheaza-te!",
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

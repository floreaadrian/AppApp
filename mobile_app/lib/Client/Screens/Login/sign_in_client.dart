import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:sefii_flutter_x/Model/user_info.dart';
import 'package:sefii_flutter_x/Providers/auth_provider.dart';

class SignInClient extends StatefulWidget {
  @override
  _SignInClientState createState() => _SignInClientState();
}

class _SignInClientState extends State<SignInClient> {
  String name;
  String email;
  String username;
  String phone;
  String password;
  String confirmPassword;
  ProgressDialog pr;
  RegExp regExp = new RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
  );

  @override
  void initState() {
    super.initState();
    pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: false);
    pr.style(
      message: 'Waiting to sign in...',
      borderRadius: 10.0,
      backgroundColor: Colors.grey[200],
      progressWidget: CircularProgressIndicator(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );
  }

  List<String> verificaInput() {
    List<String> temp = [];
    if (name == "" || name == null) temp.add("Nume gol");
    if (email == "" || email == null) temp.add("Email gol");
    if (username == "" || username == null) temp.add("Username gol");
    if (phone == "" || phone == null) temp.add("Telefon gol");
    if (password == "" || password == null) temp.add("Parola e goala");
    if (password != confirmPassword) temp.add("Parolele nu sunt egale");
    // if (!regExp.hasMatch(password))
    //   temp.add("Parola nu e suficient de puternica");
    return temp;
  }

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
                )
              ],
            )
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
              height: 590,
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
                        style: TextStyle(color: theme.primaryColor),
                        decoration: InputDecoration(
                            hintText: "Nume",
                            hintStyle: TextStyle(
                              color: theme.splashColor,
                            ),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.person,
                              color: theme.splashColor,
                            )),
                        onChanged: (value) => name = value,
                      )),
                  Container(
                    child: Divider(
                      color: theme.accentColor,
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        style: TextStyle(color: theme.primaryColor),
                        decoration: InputDecoration(
                            hintText: "Username",
                            hintStyle: TextStyle(
                              color: theme.splashColor,
                            ),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.person,
                              color: theme.splashColor,
                            )),
                        onChanged: (value) => username = value,
                      )),
                  Container(
                    child: Divider(
                      color: theme.accentColor,
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style: TextStyle(color: theme.primaryColor),
                        decoration: InputDecoration(
                            hintText: "Numar telefon",
                            hintStyle: TextStyle(
                              color: theme.splashColor,
                            ),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.phone,
                              color: theme.splashColor,
                            )),
                        onChanged: (value) => phone = value,
                      )),
                  Container(
                    child: Divider(
                      color: theme.accentColor,
                    ),
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(color: theme.primaryColor),
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
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      style: TextStyle(
                        color: theme.primaryColor,
                      ),
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
                      obscureText: true,
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
                  Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextField(
                        style: TextStyle(
                          color: theme.primaryColor,
                        ),
                        decoration: InputDecoration(
                            hintText: "Confirma parola",
                            hintStyle: TextStyle(
                              color: theme.splashColor,
                            ),
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.lock,
                              color: theme.splashColor,
                            )),
                        obscureText: true,
                        onChanged: (value) => confirmPassword = value,
                      )),
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
                  Icons.person,
                ),
              ),
            ],
          ),
          Container(
            height: 610,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: RaisedButton(
                onPressed: () async {
                  final provider =
                      Provider.of<AuthProvider>(context, listen: false);
                  List<String> errori = [];
                  errori = verificaInput();
                  if (errori.length > 0) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.ERROR,
                      animType: AnimType.BOTTOMSLIDE,
                      tittle: 'Invalid',
                      desc: errori.join("\n"),
                      btnCancelOnPress: () {},
                      btnCancelText: "Ok",
                    ).show();
                  } else {
                    UserInfo userInfo = new UserInfo(
                      name: name,
                      phone: int.parse(phone),
                      email: email,
                      username: username,
                    );
                    pr.show();
                    bool flag = await provider.signUpClient(userInfo, password);
                    await pr.hide();
                    if (flag) {
                      Navigator.pop(context);
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.ERROR,
                        animType: AnimType.BOTTOMSLIDE,
                        tittle: 'Eroare',
                        desc:
                            "A fost intaminata o eroare\nTe rugam sa incerci din nou",
                        btnCancelOnPress: () {},
                        btnCancelText: "Ok",
                      ).show();
                    }
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40.0)),
                child: Text(
                  "Inregristraza-te!",
                  style: TextStyle(color: Colors.white70),
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

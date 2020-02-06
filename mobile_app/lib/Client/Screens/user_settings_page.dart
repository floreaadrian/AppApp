import 'package:card_settings/card_settings.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:flutter/material.dart';
import 'package:sefii_flutter_x/Client/Controller/user_settings_controller.dart';
import 'package:sefii_flutter_x/Client/Widgets/user_drawer.dart';
import 'package:sefii_flutter_x/Model/user_info.dart';

import '../../route.dart';

class UserSetingsPage extends StatefulWidget {
  UserSetingsPage({Key key}) : super(key: key);

  @override
  _UserSetingsPageState createState() => _UserSetingsPageState();
}

class _UserSetingsPageState extends State<UserSetingsPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  UserSettingsController controller = new UserSettingsController();
  String password = "";
  String confirmPassword = "";
  DateTime dob;
  Future _details;
  RegExp regExp = new RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
  );

  @override
  void initState() {
    super.initState();
    _details = controller.getDetails();
  }

  bool validateSamePassword() {
    if (password == confirmPassword) return true;
    return false;
  }

  bool validateStrongPassword() {
    //print(regExp.hasMatch(password));
    //return regExp.hasMatch(password);
    return true;
  }

  void saveForm() {
    controller.changeSettings(dob, password);
  }

  Widget settingsBody(BuildContext context) {
    return FutureBuilder(
      future: _details,
      builder: (context, avalibleDataSnap) {
        if (avalibleDataSnap.connectionState == ConnectionState.done) {
          if (avalibleDataSnap.data == null) return Container();
          dob = avalibleDataSnap.data.dob;
          return Form(
            key: _globalKey,
            child: Theme(
              data: Theme.of(context).copyWith(
                accentColor:
                    Theme.of(context).primaryColor, // used for card headers
                cardColor: Theme.of(context).splashColor,
                inputDecorationTheme: InputDecorationTheme(
                  labelStyle: TextStyle(fontSize: 10), // style for labels
                ),
              ),
              child: CardSettings(
                contentAlign: TextAlign.left,
                shrinkWrap: true,
                children: <Widget>[
                  CardSettingsHeader(label: 'Informatii generale'),
                  CardSettingsDatePicker(
                    label: "Data de nastere",
                    onChanged: (date) => dob = date,
                    firstDate: DateTime.utc(1970),
                    initialValue: dob,
                    lastDate: DateTime.utc(2010),
                  ),
                  CardSettingsHeader(
                    label: 'Schimba parola',
                  ),
                  CardSettingsPassword(
                      label: 'Parola',
                      initialValue: "",
                      validator: (value) {
                        if (!validateStrongPassword())
                          return "Not strong enough";
                        return "";
                      },
                      showErrorIOS: !validateStrongPassword(),
                      onChanged: (value) {
                        password = value;
                      }),
                  CardSettingsPassword(
                      label: 'Confirma Parola',
                      initialValue: "",
                      validator: (value) {
                        if (!validateSamePassword())
                          return "Nu sunt aceleasi parole";
                        return "";
                      },
                      showErrorIOS: !validateSamePassword(),
                      onChanged: (value) {
                        confirmPassword = value;
                      }),
                ],
              ),
            ),
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
      appBar: AppBar(
        title: Text("Setari"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                SEARCH_ROUTE,
                (Route<dynamic> route) => false,
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveForm,
            tooltip: "Salveaza informatiile",
          )
        ],
      ),
      drawer: UserDrawer(
        userInfo: UserInfo(
          email: "ok@yahoo.com",
          name: "ok",
        ),
      ),
      body: settingsBody(context),
    );
  }
}

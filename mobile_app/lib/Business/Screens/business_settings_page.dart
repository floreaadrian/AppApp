import 'package:card_settings/card_settings.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:flutter/material.dart';
import 'package:sefii_flutter_x/Business/Controller/bussines_settings_controller.dart';
import 'package:sefii_flutter_x/Business/Widgets/business_drawer.dart';

class BusinessSetingsPage extends StatefulWidget {
  BusinessSetingsPage({Key key}) : super(key: key);

  @override
  _BusinessSetingsPageState createState() => _BusinessSetingsPageState();
}

class _BusinessSetingsPageState extends State<BusinessSetingsPage> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String password = "";
  String confirmPassword = "";
  String category = "";
  String cartier = "";
  int telefon;
  BussinesSettingsController controller = new BussinesSettingsController();
  RegExp regExp = new RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
  );

  bool validateSamePassword() {
    if (password == confirmPassword) return true;
    return false;
  }

  bool validateStrongPassword() {
    print(regExp.hasMatch(password));
    //return regExp.hasMatch(password);
    return true;
  }

  Widget settingsBody(BuildContext context) {
    return FutureBuilder(
      future: controller.getDetails(),
      builder: (context, avalibleDataSnap) {
        if (avalibleDataSnap.connectionState == ConnectionState.done) {
          if (avalibleDataSnap.data == null) return Container();
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
                  CardSettingsText(
                    initialValue: avalibleDataSnap.data.phoneNumber.toString(),
                    label: "Numar de telefon",
                    validator: (value) {
                      if (int.tryParse(value) == null) return "Format invalid";
                      return "";
                    },
                    onChanged: (newPhone) => telefon = int.parse(newPhone),
                    keyboardType: TextInputType.phone,
                  ),
                  CardSettingsListPicker(
                    label: "Cartier",
                    initialValue: avalibleDataSnap.data.cartier,
                    options: [
                      "Manastur",
                      "Marasti",
                      "Iris",
                      "Centru",
                    ],
                    onChanged: (value) => cartier = value,
                  ),
                  CardSettingsListPicker(
                    initialValue: avalibleDataSnap.data.category,
                    label: "Categorie",
                    options: [
                      "Dentist",
                      "Doctor",
                      "Frizer",
                    ],
                    onChanged: (value) => category = value,
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

  void saveForm() {
    controller.changeSettings(telefon, cartier, category, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setari"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveForm,
            tooltip: "Salveaza informatiile",
          )
        ],
      ),
      drawer: BusinessDrawer(),
      body: settingsBody(context),
    );
  }
}

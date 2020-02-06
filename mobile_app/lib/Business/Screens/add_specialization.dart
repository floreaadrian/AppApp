import 'package:card_settings/card_settings.dart';
import 'package:card_settings/widgets/card_settings_panel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sefii_flutter_x/Business/Providers/specialization_provider.dart';
import 'package:sefii_flutter_x/Business/Widgets/multi_select.dart';
import 'package:sefii_flutter_x/Model/specialization.dart';

class AddSpecialization extends StatefulWidget {
  AddSpecialization({Key key}) : super(key: key);

  @override
  _AddSpecializationState createState() => _AddSpecializationState();
}

class _AddSpecializationState extends State<AddSpecialization> {
  Specialization specialization;
  TimeOfDay startHour;
  TimeOfDay endHour;
  String nume;
  String descriere;
  int timpRezervare;
  List<String> zileSelectate;
  List<String> optiuni = [
    "Luni",
    "Marti",
    "Miercuri",
    "Joi",
    "Vineri",
    "Sambata",
    "Duminica"
  ];

  Container getToolbar(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      child: new BackButton(
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text(
              "Zile Disponibile",
              style: TextStyle(color: Colors.black),
            ),
            content: MultiSelectChip(
              optiuni,
              onSelectionChanged: (selectedList) {
                setState(() {
                  zileSelectate = selectedList;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Selecteaza"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  Widget formBuild(BuildContext context) {
    return Form(
      child: Theme(
        data: Theme.of(context).copyWith(
          accentColor: Theme.of(context).primaryColor, // used for card headers
          cardColor: Theme.of(context).splashColor,
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(fontSize: 10), // style for labels
          ),
          textTheme: TextTheme(
            button: TextStyle(
                color: Colors.deepPurple[900]), // style of button text
            subhead:
                TextStyle(color: Colors.deepOrange[900]), // style of input text
          ),
        ),
        child: CardSettings(
          children: <Widget>[
            CardSettingsHeader(label: "Creaza o specializare"),
            CardSettingsText(
              label: "Numele:",
              icon: Icon(Icons.person),
              onChanged: (data) => nume = data,
              onSaved: (data) => nume = data,
            ),
            CardSettingsParagraph(
              label: "Descrierea:",
              icon: Icon(FontAwesomeIcons.pen),
              onChanged: (data) => descriere = data,
              onSaved: (data) => descriere = data,
            ),
            CardSettingsTimePicker(
              label: "De la: ",
              icon: Icon(FontAwesomeIcons.clock),
              onChanged: (data) => startHour = data,
              onSaved: (data) => startHour = data,
            ),
            CardSettingsTimePicker(
              label: "Pana la: ",
              icon: Icon(FontAwesomeIcons.clock),
              onChanged: (data) => endHour = data,
              onSaved: (data) => endHour = data,
            ),
            CardSettingsNumberPicker(
              label: "Minute/rez:",
              min: 10,
              max: 60,
              icon: Icon(FontAwesomeIcons.hourglass),
              onChanged: (data) => timpRezervare = data,
              onSaved: (data) => timpRezervare = data,
            ),
            CardSettingsButton(
              label: "Selecteaza zile",
              onPressed: () {
                _showReportDialog();
              },
            ),
            CardSettingsButton(
              backgroundColor: Theme.of(context).backgroundColor,
              label: "Salveaza",
              onPressed: () async {
                final provider =
                    Provider.of<SpecializationProvider>(context, listen: false);
                await provider.addSpecialization(
                  nume: nume,
                  descriere: descriere,
                  startHour: startHour,
                  endHour: endHour,
                  timpRezervare: timpRezervare,
                  zileSelectate: zileSelectate,
                );
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adauga Specializare"),
      ),
      body: Container(
        color: Colors.grey,
        child: formBuild(context),
      ),
    );
  }
}

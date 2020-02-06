import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sefii_flutter_x/Client/Providers/reservation_maker_provider.dart';
import 'package:sefii_flutter_x/Client/Widgets/toolbar.dart';
import 'package:sefii_flutter_x/Model/avalible_date.dart';
import 'package:sefii_flutter_x/Model/specialization_settings.dart';
import 'package:sefii_flutter_x/route.dart';

enum ButtonStatus {
  none,
  selected,
  error,
  waiting,
}

class MakeReservationPage extends StatefulWidget {
  final SpecializationSettings specialization;

  MakeReservationPage({Key key, @required this.specialization})
      : super(key: key);

  @override
  _MakeReservationPageState createState() => _MakeReservationPageState();
}

class _MakeReservationPageState extends State<MakeReservationPage> {
  ButtonStatus buttonStatus;
  AvalibleHour selectedHour;
  int selectedIndex;
  Future<List<AvalibleHour>> future;
  @override
  void initState() {
    final provider =
        Provider.of<ReservationMakerProvider>(context, listen: false);
    super.initState();
    provider.initProvider(widget.specialization, DateTime.now());
    future = provider.getData();
    setState(() {
      buttonStatus = ButtonStatus.none;
    });
  }

  Widget getDates(BuildContext context) {
    final provider =
        Provider.of<ReservationMakerProvider>(context, listen: true);
    if (provider.needsToUpdate) {
      future = provider.getData();
    }
    return FutureBuilder(
      future: future,
      builder: (context, avalibleDataSnap) {
        if (avalibleDataSnap.connectionState == ConnectionState.done) {
          if (avalibleDataSnap.data == null) return Container();
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(bottom: 30),
            itemCount: avalibleDataSnap.data.length,
            itemBuilder: (context, index) {
              return avalibleHourWidget(
                key: Key(index.toString()),
                context: context,
                avalibleHour: avalibleDataSnap.data[index],
                index: index,
              );
            },
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  GestureDetector avalibleHourWidget({
    Key key,
    BuildContext context,
    AvalibleHour avalibleHour,
    int index,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedHour = avalibleHour;
          selectedIndex = index;
          buttonStatus = ButtonStatus.selected;
        });
      },
      child: Card(
        elevation: 8.0,
        color: selectedIndex != null && selectedIndex == index
            ? Theme.of(context).primaryColor
            : Theme.of(context).cardColor,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: <Widget>[
              Text(
                avalibleHour.startHour.toString() +
                    ":" +
                    avalibleHour.startMinute.toString() +
                    "  -  " +
                    avalibleHour.endHour.toString() +
                    ":" +
                    avalibleHour.endMinute.toString(),
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).backgroundColor,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  IconData selectIcon() {
    IconData toReturn;
    switch (buttonStatus) {
      case ButtonStatus.none:
        toReturn = Icons.warning;
        break;
      case ButtonStatus.selected:
        toReturn = Icons.add;
        break;
      case ButtonStatus.error:
        toReturn = Icons.error;
        break;
      case ButtonStatus.waiting:
        toReturn = Icons.refresh;
        break;
    }
    return toReturn;
  }

  Color selectColor() {
    Color toReturn;
    switch (buttonStatus) {
      case ButtonStatus.none:
        toReturn = Colors.black;
        break;
      case ButtonStatus.selected:
        toReturn = Colors.green;
        break;
      case ButtonStatus.error:
        toReturn = Colors.red;
        break;
      case ButtonStatus.waiting:
        toReturn = Colors.blue;
        break;
    }
    return toReturn;
  }

  String selectStringText() {
    String toReturn;
    switch (buttonStatus) {
      case ButtonStatus.none:
        toReturn = "Neselectat";
        break;
      case ButtonStatus.selected:
        toReturn = "Rezerva";
        break;
      case ButtonStatus.error:
        toReturn = "Eroare!";
        break;
      case ButtonStatus.waiting:
        toReturn = "Asteptam..";
        break;
    }
    return toReturn;
  }

  Widget confirmButton(BuildContext context) {
    final provider =
        Provider.of<ReservationMakerProvider>(context, listen: true);
    return GestureDetector(
      onTap: () async {
        if (buttonStatus == ButtonStatus.selected) {
          setState(() {
            buttonStatus = ButtonStatus.waiting;
          });
          bool result = await provider.confirmReservation(selectedHour);
          if (result == false) {
            setState(() {
              buttonStatus = ButtonStatus.error;
              selectedHour = null;
              selectedIndex = null;
            });
          } else {
            Navigator.pushNamedAndRemoveUntil(
              context,
              RESERVATION_PAGE_ROUTE,
              (Route<dynamic> route) => false,
            );
          }
        }
      },
      child: Card(
        elevation: 8.0,
        color: selectColor(),
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
              child: new CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(selectIcon()),
              ),
            ),
            title: Text(
              selectStringText() ?? "ok",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void dateChanged(BuildContext context, DateTime date) {
    final provider =
        Provider.of<ReservationMakerProvider>(context, listen: false);
    setState(() {
      selectedHour = null;
      selectedIndex = null;
      buttonStatus = ButtonStatus.none;
    });
    provider.changeDate(date);
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<ReservationMakerProvider>(context, listen: true);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        child: Stack(
          children: <Widget>[
            Container(
              margin: new EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 40,
              ),
              child: Column(
                children: <Widget>[
                  DatePickerTimeline(
                    provider.selectedDate,
                    onDateChange: (date) {
                      dateChanged(context, date);
                    },
                  ),
                  Divider(
                    thickness: 2,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 300,
                    child: getDates(context),
                  ),
                  confirmButton(context),
                  // )
                ],
              ),
            ),
            getToolbar(context),
          ],
        ),
      ),
    );
  }
}

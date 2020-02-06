import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:sefii_flutter_x/Business/Controller/calendar_controller.dart';
import 'package:sefii_flutter_x/Business/Repository/calendar_repository.dart';
import 'package:sefii_flutter_x/Model/business_event.dart';
import 'package:sefii_flutter_x/Model/specialization_settings.dart';

class SpecializationReservation extends StatefulWidget {
  final SpecializationSettings specialization;
  SpecializationReservation({Key key, @required this.specialization})
      : super(key: key);

  @override
  _SpecializationReservationState createState() =>
      _SpecializationReservationState();
}

class _SpecializationReservationState extends State<SpecializationReservation> {
  bool needToUpdate = false;
  Future future;
  CalendarController calendarController =
      new CalendarController(new CalendarRepository());

  @override
  void initState() {
    super.initState();
    future =
        calendarController.getForTodaySpecialization(widget.specialization);
  }

  Widget resCard(BuildContext context, BusinessEvent event, String title) {
    return Expanded(
      child: Container(
        height: 250,
        decoration: BoxDecoration(),
        width: title == "Ultima rezervare"
            ? 300
            : MediaQuery.of(context).size.width - 30 / 2,
        child: Card(
          elevation: 10,
          margin: EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  title ?? "ce",
                  style: TextStyle(fontSize: 30.0),
                ),
                Text(event.userName ?? "ce"),
                Text(event.avalibleHour.startHour.toString() +
                    ":" +
                    event.avalibleHour.startMinute.toString()),
                Text(event.avalibleHour.endHour.toString() +
                    ":" +
                    event.avalibleHour.endMinute.toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nowAndFutureReservation(BuildContext context) {
    if (needToUpdate) {
      future =
          calendarController.getForTodaySpecialization(widget.specialization);
      needToUpdate = false;
    }
    int minutesNow = TimeOfDay.now().hour * 60 + TimeOfDay.now().minute;
    return FutureBuilder(
      future: future,
      builder: (context, avalibleDataSnap) {
        if (avalibleDataSnap.connectionState == ConnectionState.done) {
          if (avalibleDataSnap.data == null) return Container();
          int indexFoundAt = -1;
          for (int i = 0; i < avalibleDataSnap.data.length; ++i) {
            int minutesElem =
                avalibleDataSnap.data[i].avalibleHour.startHour * 60 +
                    avalibleDataSnap.data[i].avalibleHour.startMinute +
                    widget.specialization.duration;
            if (minutesElem > minutesNow) {
              indexFoundAt = i;
              break;
            }
          }
          if (indexFoundAt == -1) {
            return Container(
              color: Theme.of(context).splashColor,
              height: 100,
              child: Center(child: Text("Nu mai ai rezervari azi!")),
            );
          } else if (indexFoundAt == avalibleDataSnap.data.length - 1) {
            return Container(
                width: MediaQuery.of(context).size.width - 30,
                child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  resCard(context, avalibleDataSnap.data[indexFoundAt],
                      "Ultima rezervare")
                ]));
          }
          return Container(
            width: MediaQuery.of(context).size.width - 30,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                resCard(context, avalibleDataSnap.data[indexFoundAt], "Acum"),
                resCard(context, avalibleDataSnap.data[indexFoundAt + 1],
                    "Urmatoarea"),
              ],
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

  void saveToCalendar(BusinessEvent bevent) {
    final Event event = Event(
      title: "Rezervarea lui " + bevent.userName,
      startDate: bevent.dateTime.add(
        new Duration(
          hours: bevent.avalibleHour.startHour,
          minutes: bevent.avalibleHour.startMinute,
        ),
      ),
      endDate: bevent.dateTime.add(
        new Duration(
          hours: bevent.avalibleHour.endHour,
          minutes: bevent.avalibleHour.endMinute,
        ),
      ),
    );
    print(bevent.toJson());
    Add2Calendar.addEvent2Cal(event);
  }

  Widget specializationDescription(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Card(
        color: Theme.of(context).primaryColor,
        elevation: 10,
        child: Center(
          child: Text(
            widget.specialization.desc,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget eventWidget(BusinessEvent event) {
    return GestureDetector(
      onTap: () {
        saveToCalendar(event);
      },
      child: Card(
        color: Theme.of(context).accentColor,
        elevation: 10.0,
        child: ListTile(
          title: Center(child: Text(event.userName)),
          subtitle: Column(
            children: <Widget>[
              Text(event.avalibleHour.startHour.toString() +
                  ":" +
                  event.avalibleHour.startMinute.toString()),
              Text(event.specializationName),
            ],
          ),
        ),
      ),
    );
  }

  Widget reservationList(BuildContext context) {
    if (needToUpdate) {
      future =
          calendarController.getForTodaySpecialization(widget.specialization);
      needToUpdate = false;
    }
    return FutureBuilder(
      future: future,
      builder: (context, avalibleDataSnap) {
        if (avalibleDataSnap.connectionState == ConnectionState.done) {
          if (avalibleDataSnap.data == null) return Container();
          return ListView.builder(
            shrinkWrap: true,
            // scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(bottom: 30),
            itemCount: avalibleDataSnap.data.length,
            itemBuilder: (context, index) {
              return eventWidget(avalibleDataSnap.data[index]);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.specialization.name)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                needToUpdate = true;
              });
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              nowAndFutureReservation(context),
              specializationDescription(context),
              Flexible(
                flex: 1,
                child: reservationList(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}

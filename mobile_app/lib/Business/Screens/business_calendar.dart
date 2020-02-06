import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:sefii_flutter_x/Business/Controller/calendar_controller.dart';
import 'package:sefii_flutter_x/Business/Repository/calendar_repository.dart';
import 'package:sefii_flutter_x/Business/Widgets/business_drawer.dart';
import 'package:sefii_flutter_x/Model/business_event.dart';

class BusinessCalendar extends StatefulWidget {
  const BusinessCalendar({Key key}) : super(key: key);

  @override
  _BusinessCalendarState createState() => _BusinessCalendarState();
}

class _BusinessCalendarState extends State<BusinessCalendar> {
  DateTime time = DateTime.now();
  bool needToUpdate = false;
  CalendarController calendarController =
      new CalendarController(new CalendarRepository());
  Future<List<BusinessEvent>> future;

  @override
  void initState() {
    super.initState();
    future = calendarController.getAll(time);
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
    Add2Calendar.addEvent2Cal(event);
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

  Widget createListOfEvents(BuildContext context) {
    if (needToUpdate) {
      future = calendarController.getAll(time);
      needToUpdate = false;
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

  Widget createCalendar(BuildContext context) {
    return Container(
      color: Theme.of(context).splashColor,
      child: Column(
        children: <Widget>[
          Calendar(
            isExpandable: true,
            onDateSelected: (date) {
              setState(() {
                needToUpdate = true;
                time = date;
              });
            },
          ),
          new Expanded(
            child: createListOfEvents(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                needToUpdate = true;
              });
            },
          )
        ],
      ),
      drawer: BusinessDrawer(),
      body: createCalendar(context),
    );
  }
}

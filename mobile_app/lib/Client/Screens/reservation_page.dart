import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sefii_flutter_x/Client/Providers/reservation_list_provider.dart';
import 'package:sefii_flutter_x/Client/Widgets/user_drawer.dart';
import 'package:sefii_flutter_x/Model/reservation.dart';
import 'package:sefii_flutter_x/Model/user_info.dart';

import '../../route.dart';

class ReservationPage extends StatelessWidget {
  const ReservationPage({Key key}) : super(key: key);

  String createDateText(Reservation reservation) {
    return "Data: " +
        reservation.dateTime.day.toString() +
        "." +
        reservation.dateTime.month.toString() +
        "." +
        reservation.dateTime.year.toString() +
        " - " +
        reservation.avalibleHour.startHour.toString() +
        ":" +
        reservation.avalibleHour.startMinute.toString();
  }

  void saveToCalendar(Reservation reservation) {
    final Event event = Event(
      title: "Rezervare la " + reservation.business.title,
      description: reservation.specializaton,
      location: reservation.business.adress,
      startDate: reservation.dateTime,
      endDate: reservation.dateTime,
    );
    Add2Calendar.addEvent2Cal(event);
  }

  Widget reservationWidget({
    Key key,
    BuildContext context,
    Reservation reservation,
  }) {
    final provider =
        Provider.of<ReservationListProvider>(context, listen: false);
    return Card(
      elevation: 8.0,
      color: Theme.of(context).cardColor,
      margin: new EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        child: ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
          leading: GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                BUSINESS_USER_INFO_ROUTE,
                arguments: reservation.business,
              );
            },
            child: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: new BoxDecoration(
                border: new Border(
                  right: new BorderSide(
                    width: 1.0,
                    color: Colors.white24,
                  ),
                ),
              ),
              child: CircleAvatar(
                  backgroundColor: Colors.transparent, child: Text("D")),
            ),
          ),
          title: GestureDetector(
            onLongPress: () {
              saveToCalendar(reservation);
            },
            child: Text(
              reservation.business.title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: GestureDetector(
            onLongPress: () {
              saveToCalendar(reservation);
            },
            child: Container(
              padding: EdgeInsets.only(top: 3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    createDateText(reservation),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Divider(
                    color: Theme.of(context).primaryColor,
                    thickness: 2,
                  ),
                  Text(
                    reservation.specializaton,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
          trailing: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    AwesomeDialog(
                        context: context,
                        dialogType: DialogType.ERROR,
                        animType: AnimType.BOTTOMSLIDE,
                        tittle: 'Sterge',
                        desc: 'Esti sigur ca vrei sa stergi rezervarea?',
                        btnCancelOnPress: () {},
                        btnOkOnPress: () async {
                          bool result =
                              await provider.deleteReservation(reservation);
                          if (result) {
                            provider.refresh();
                          } else {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.ERROR,
                              animType: AnimType.BOTTOMSLIDE,
                              tittle: 'Eroare',
                              desc: 'Rezervarea nu a putut fi stearsa!',
                              btnCancelOnPress: () {},
                              btnCancelText: "Ok",
                            ).show();
                          }
                        }).show();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: SizedBox(
                      height: 15.0,
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    saveToCalendar(reservation);
                  },
                  child: SizedBox(
                    height: 15.0,
                    child: Icon(
                      Icons.save,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget reservationList(BuildContext context) {
    final provider =
        Provider.of<ReservationListProvider>(context, listen: true);
    return FutureBuilder(
      future: provider.getData(),
      builder: (context, avalibleDataSnap) {
        if (avalibleDataSnap.connectionState == ConnectionState.done) {
          if (avalibleDataSnap.data == null) return Container();
          return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(bottom: 30),
            itemCount: avalibleDataSnap.data.length,
            itemBuilder: (context, index) {
              return reservationWidget(
                key: Key(index.toString()),
                context: context,
                reservation: avalibleDataSnap.data[index],
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

  @override
  Widget build(BuildContext context) {
    final provider =
        Provider.of<ReservationListProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Rezervarile tale"),
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
            icon: Icon(Icons.refresh),
            onPressed: () {
              provider.refresh();
            },
          ),
        ],
      ),
      drawer: UserDrawer(
        userInfo: UserInfo(
          email: "ok@yahoo.com",
          name: "ok",
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: reservationList(context),
      ),
    );
  }
}

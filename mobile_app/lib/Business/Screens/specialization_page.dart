import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sefii_flutter_x/Business/Providers/specialization_provider.dart';
import 'package:sefii_flutter_x/Business/Widgets/business_drawer.dart';
import 'package:sefii_flutter_x/Model/specialization_settings.dart';

import '../../route.dart';

class SpecializationPage extends StatelessWidget {
  const SpecializationPage({Key key}) : super(key: key);

  Widget specializationWidget(
      SpecializationSettings specialization, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          SPECIALIZATION_RESERVATION_PAGE_ROUTE,
          arguments: specialization,
        );
      },
      child: Card(
        color: Theme.of(context).primaryColor,
        elevation: 10.0,
        child: ListTile(
          title: Center(
            child: Text(
              specialization.name,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
              ),
            ),
          ),
          subtitle: Column(
            children: <Widget>[
              Text(
                "Deschis de la: " +
                    specialization.avalibleHour.startHour.toString() +
                    ":" +
                    specialization.avalibleHour.startMinute.toString(),
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
              Text(
                "Inchidem la: " +
                    specialization.avalibleHour.endHour.toString() +
                    ":" +
                    specialization.avalibleHour.endMinute.toString(),
                style: TextStyle(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget specializariList(BuildContext context) {
    final provider = Provider.of<SpecializationProvider>(context, listen: true);
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
              return specializationWidget(
                  avalibleDataSnap.data[index], context);
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
        title: Text("Specializari"),
      ),
      drawer: BusinessDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            ADD_SPECIALIZATION_PAGE_ROUTE,
          );
        },
        child: Icon(Icons.add),
      ),
      body: Container(
        child: specializariList(context),
      ),
    );
  }
}

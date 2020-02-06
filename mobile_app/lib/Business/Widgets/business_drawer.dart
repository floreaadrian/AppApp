import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sefii_flutter_x/Business/Repository/business_settings_repository.dart';
import 'package:sefii_flutter_x/Model/business_info.dart';
import 'package:sefii_flutter_x/Providers/auth_provider.dart';

import '../../route.dart';

class BusinessDrawer extends StatefulWidget {
  BusinessDrawer({Key key}) : super(key: key);

  @override
  _BusinessDrawerState createState() => _BusinessDrawerState();
}

class _BusinessDrawerState extends State<BusinessDrawer> {
  final Future<BusinessInfo> future =
      new BussinesSettingsRepository().getDetails();

  Widget header(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, avalibleDataSnap) {
        if (avalibleDataSnap.connectionState == ConnectionState.done) {
          if (avalibleDataSnap.data == null) return Container();
          return UserAccountsDrawerHeader(
            accountName: Text(avalibleDataSnap.data.title),
            accountEmail: Text(avalibleDataSnap.data.email),
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
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      width: 250.0,
      child: Drawer(
        child: Row(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  header(context),
                  ListTile(
                    leading: Icon(
                      Icons.calendar_today,
                      color: theme.accentColor,
                    ),
                    title: Text("Calendar"),
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        BUSINESS_CALENDAR_PAGE_ROUTE,
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.work,
                      color: theme.accentColor,
                    ),
                    title: Text("Specializari"),
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        SPECIALIZATIONS_PAGE_ROUTE,
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: theme.accentColor,
                    ),
                    title: Text("Settings"),
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        BUSINESS_SETTINGS_PAGE_ROUTE,
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.powerOff,
                      color: theme.accentColor,
                    ),
                    title: Text("Logout"),
                    onTap: () async {
                      final provider =
                          Provider.of<AuthProvider>(context, listen: false);
                      await provider.logout();
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        DEFAULT_ROUTE,
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                  Divider(
                    thickness: 2,
                    color: Theme.of(context).accentColor,
                  ),
                  ListTile(
                    title: Text("About us"),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

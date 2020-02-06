import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sefii_flutter_x/Client/Repository/user_settings_repository.dart';
import 'package:sefii_flutter_x/Model/user_info.dart';
import 'package:sefii_flutter_x/Providers/auth_provider.dart';

import '../../route.dart';

class UserDrawer extends StatefulWidget {
  final UserInfo userInfo;

  UserDrawer({
    Key key,
    @required this.userInfo,
  }) : super(key: key);

  @override
  _UserDrawerState createState() => _UserDrawerState();
}

class _UserDrawerState extends State<UserDrawer> {
  final Future<UserInfo> future = new UserSettingsRepository().getDetails();

  Widget header(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, avalibleDataSnap) {
        if (avalibleDataSnap.connectionState == ConnectionState.done) {
          if (avalibleDataSnap.data == null) return Container();
          return UserAccountsDrawerHeader(
            accountName: Text(avalibleDataSnap.data.name),
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
                    title: Text("Reservations"),
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        RESERVATION_PAGE_ROUTE,
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
                        USER_SETTINGS_PAGE_ROUTE,
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sefii_flutter_x/Business/Screens/business_calendar.dart';
import 'package:sefii_flutter_x/Client/Screens/search_page.dart';
import 'package:sefii_flutter_x/Providers/auth_provider.dart';

import 'choose_user_type.dart';

class HomePage extends StatefulWidget {
  final String token;
  const HomePage({Key key, this.token}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget whatToDo(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: true);
    return FutureBuilder(
      future: provider.tokenInfo(),
      builder: (context, avalibleDataSnap) {
        if (avalibleDataSnap.connectionState == ConnectionState.done) {
          if (avalibleDataSnap.data == null) return ChooseUserType();
          if (avalibleDataSnap.data[0] == "user")
            return SearchPage();
          else
            return BusinessCalendar();
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
    return whatToDo(context);
  }
}

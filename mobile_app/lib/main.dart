import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sefii_flutter_x/Providers/auth_provider.dart';
import 'package:sefii_flutter_x/route.dart';
import 'package:sefii_flutter_x/theme.dart';

import 'Business/Providers/specialization_provider.dart';
import 'Client/Providers/reservation_list_provider.dart';
import 'Client/Providers/reservation_maker_provider.dart';
import 'Client/Providers/search_provider.dart';
import 'Screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SearchProvider>.value(value: SearchProvider()),
        ChangeNotifierProvider<AuthProvider>.value(value: AuthProvider()),
        ChangeNotifierProvider<SpecializationProvider>.value(
            value: SpecializationProvider()),
        ChangeNotifierProvider<ReservationListProvider>.value(
            value: ReservationListProvider()),
        ChangeNotifierProvider<ReservationMakerProvider>.value(
            value: ReservationMakerProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: Router.generateRoute,
      theme: lightTheme,
      home: HomePage(),
    );
  }
}

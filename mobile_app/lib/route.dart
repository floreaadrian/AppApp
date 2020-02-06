import 'package:flutter/material.dart';
import 'package:sefii_flutter_x/Business/Screens/add_specialization.dart';
import 'package:sefii_flutter_x/Business/Screens/business_calendar.dart';
import 'package:sefii_flutter_x/Business/Screens/business_settings_page.dart';
import 'package:sefii_flutter_x/Business/Screens/specialization_page.dart';
import 'package:sefii_flutter_x/Business/Screens/specialization_reservation.dart';
import 'package:sefii_flutter_x/Client/Screens/business_info_page.dart';
import 'package:sefii_flutter_x/Client/Screens/reservation_page.dart';
import 'package:sefii_flutter_x/Client/Screens/specialization_select_page.dart';
import 'package:sefii_flutter_x/Client/Screens/user_settings_page.dart';
import 'package:sefii_flutter_x/Model/specialization_settings.dart';

import 'Business/Screens/Login/log_in_business.dart';
import 'Business/Screens/Login/sign_in_business.dart';
import 'Client/Screens/Login/log_in_client.dart';
import 'Client/Screens/Login/sign_in_client.dart';
import 'Client/Screens/make_reservation_page.dart';
import 'Client/Screens/search_page.dart';
import 'Model/business_info.dart';
import 'Screens/choose_user_type.dart';
import 'Screens/forgot_password.dart';
import 'Screens/home_screen.dart';

const String DEFAULT_ROUTE = '/';
const String CHOOSE_USER_TYPE_ROUTE = '/choose_user_type';
const String SIGN_IN_CLIENT_ROUTE = '/sign_in_client';
const String SIGN_IN_BUSINESS_ROUTE = '/sign_in_business';
const String LOG_IN_CLIENT_ROUTE = '/log_in_client';
const String LOG_IN_BUSINESS_ROUTE = '/log_in_business';
const String SEARCH_ROUTE = '/search';
const String BUSINESS_USER_INFO_ROUTE = '/business_user_info';
const String SPECIALIZATION_SELECT_PAGE_ROUTE = '/specialization_select_page';
const String MAKE_RESERVATION_PAGE_ROUTE = '/make_reservation_page';
const String RESERVATION_PAGE_ROUTE = '/reservation_page';
const String USER_SETTINGS_PAGE_ROUTE = '/user_settings';
const String BUSINESS_CALENDAR_PAGE_ROUTE = '/buiness_calendar';
const String BUSINESS_SETTINGS_PAGE_ROUTE = '/buiness_settings';
const String SPECIALIZATIONS_PAGE_ROUTE = '/specializations';
const String ADD_SPECIALIZATION_PAGE_ROUTE = '/add_specialization';
const String SPECIALIZATION_RESERVATION_PAGE_ROUTE =
    '/specialization_reservation';
const String FORGET_PASSWORD_PAGE_ROUTE = '/forgot_password_page';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case DEFAULT_ROUTE:
        return MaterialPageRoute(
            builder: (_) => HomePage(
                  token: '',
                ));
      case CHOOSE_USER_TYPE_ROUTE:
        return MaterialPageRoute(builder: (_) => ChooseUserType());
      case SIGN_IN_BUSINESS_ROUTE:
        return MaterialPageRoute(builder: (_) => SignInBusiness());
      case SIGN_IN_CLIENT_ROUTE:
        return MaterialPageRoute(builder: (_) => SignInClient());
      case LOG_IN_BUSINESS_ROUTE:
        return MaterialPageRoute(builder: (_) => LogInBusiness());
      case LOG_IN_CLIENT_ROUTE:
        return MaterialPageRoute(builder: (_) => LogInClient());
      case SEARCH_ROUTE:
        return MaterialPageRoute(builder: (_) => SearchPage());
      case BUSINESS_USER_INFO_ROUTE:
        var data = settings.arguments as BusinessInfo;
        return MaterialPageRoute(
          builder: (_) => BusinessInfoPage(
            businessInfo: data,
          ),
        );
      case SPECIALIZATION_SELECT_PAGE_ROUTE:
        var data = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => SpecializationSelectPage(
            bussinesId: data,
          ),
        );
      case MAKE_RESERVATION_PAGE_ROUTE:
        var data = settings.arguments as SpecializationSettings;
        return MaterialPageRoute(
          builder: (_) => MakeReservationPage(
            specialization: data,
          ),
        );
      case RESERVATION_PAGE_ROUTE:
        return MaterialPageRoute(builder: (_) => ReservationPage());
      case USER_SETTINGS_PAGE_ROUTE:
        return MaterialPageRoute(builder: (_) => UserSetingsPage());
      case BUSINESS_CALENDAR_PAGE_ROUTE:
        return MaterialPageRoute(builder: (_) => BusinessCalendar());
      case BUSINESS_SETTINGS_PAGE_ROUTE:
        return MaterialPageRoute(builder: (_) => BusinessSetingsPage());
      case SPECIALIZATIONS_PAGE_ROUTE:
        return MaterialPageRoute(builder: (_) => SpecializationPage());
      case ADD_SPECIALIZATION_PAGE_ROUTE:
        return MaterialPageRoute(builder: (_) => AddSpecialization());
      case SPECIALIZATION_RESERVATION_PAGE_ROUTE:
        var data = settings.arguments as SpecializationSettings;
        return MaterialPageRoute(
          builder: (_) => SpecializationReservation(
            specialization: data,
          ),
        );
      case FORGET_PASSWORD_PAGE_ROUTE:
        var data = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => ForgotPassword(
            type: data,
          ),
        );
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}

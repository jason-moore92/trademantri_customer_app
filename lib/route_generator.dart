import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:trapp/src/pages/NotificationListPage/notification_list_page.dart';
import 'package:trapp/src/pages/SearchLocationPage/index.dart';
import 'package:trapp/src/pages/account.dart';
import 'package:trapp/src/pages/alert_update.dart';
import 'package:trapp/src/pages/check_update.dart';
import 'package:trapp/src/pages/forgot_page.dart';
import 'package:trapp/src/pages/languages.dart';
import 'package:trapp/src/pages/login.dart';
import 'package:trapp/src/pages/pages.dart';
import 'package:trapp/src/pages/signup.dart';
import 'package:trapp/src/pages/walkthrough.dart';

import 'environment.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    Map<int, String> homeTabMap = {
      0: "Assistant Order",
      1: "Bargain Request",
      2: "home_page",
      3: "Reverse Auction",
      4: "Favorites",
    };

    switch (settings.name) {
      case '/CheckUpdates':
        return MaterialPageRoute(
          builder: (_) => CheckUpdate(),
          settings: RouteSettings(
            name: "CheckUpdates",
          ),
        );
      case '/':
        // if (Environment.checkUpdates) {
        //   return MaterialPageRoute(
        //     builder: (_) => AlertUpdate(),
        //     settings: RouteSettings(
        //       name: "AlertUpdate",
        //     ),
        //   );
        // }
        return MaterialPageRoute(
          builder: (_) => Walkthrough(),
          settings: RouteSettings(
            name: "Walkthrough",
          ),
        );
      case '/Login':
        return MaterialPageRoute(
          builder: (_) => LoginWidget(),
          settings: RouteSettings(
            name: "Login",
          ),
        );
      case '/SignUp':
        return MaterialPageRoute(
          builder: (_) => SignUpWidget(),
          settings: RouteSettings(
            name: "SignUp",
          ),
        );
      case '/Pages':
        Map<String, dynamic> params = json.decode(json.encode(args));
        return MaterialPageRoute(
          builder: (_) => PagesTestWidget(
            currentTab: params["currentTab"],
            categoryData: params["categoryData"],
          ),
          settings: RouteSettings(name: homeTabMap[params["currentTab"]]),
        );
      case '/Languages':
        return MaterialPageRoute(
          builder: (_) => LanguagesWidget(),
          settings: RouteSettings(
            name: "Languages",
          ),
        );
      case '/Profile':
        return MaterialPageRoute(
          builder: (_) => AccountWidget(),
          settings: RouteSettings(
            name: "Profile",
          ),
        );
      case '/Notifications':
        return MaterialPageRoute(
          builder: (_) => NotificationListPage(),
          settings: RouteSettings(
            name: "Notifications",
          ),
        );
      case '/Forgot':
        return MaterialPageRoute(
          builder: (_) => ForgotPage(),
          settings: RouteSettings(
            name: "Forgot",
          ),
        );
      case '/search_location':
        return MaterialPageRoute(
          builder: (_) => SearchLocationPage(),
          settings: RouteSettings(
            name: "SearchLocation",
          ),
        );
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

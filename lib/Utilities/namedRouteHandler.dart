
import 'package:ble/Material/constants.dart';
import 'package:ble/Views/device_list_view.dart';
import 'package:ble/Views/login_view.dart';
import 'package:flutter/material.dart';

import '../Views/register_view.dart';

Route<dynamic> routeHandler(RouteSettings settings) {
  WidgetBuilder builder;
  switch (settings.name) {

    case REGISTER_ROUTE:
      builder = (BuildContext _) => CreateAccount();
      break;
    case MENU_ROUTE:
      builder = (BuildContext _) => DeviceListPage();
      break;
    case LOGIN_ROUTE:
      builder = (BuildContext _) => LoginPage();
      break;
    
    default:
      throw Exception('Invalid route: ${settings.name}');
  }

  // animations
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => builder(context),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Start from the right
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
    settings: settings,
  );
}

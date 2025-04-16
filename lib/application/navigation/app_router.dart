import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:rgbremote/presentation/screens/remote_screen.dart';
import 'package:rgbremote/presentation/screens/settings_screen.dart';

class Routes {
  Routes._();
  static const String remote = '/';
  static const String settings = '/settings';
}

Route<dynamic> generatedRoutes(RouteSettings settings) {
  Widget child;

  switch (settings.name) {
    case Routes.remote:
      child = const RemoteScreen();
      break;
    case Routes.settings:
      child = const SettingsScreen();
      break;
    default:
      throw Exception('Invalid route: ${settings.name}');
  }

  return PageTransition(
    child: child,
    type: PageTransitionType.fade,
    settings: settings,
  );
}
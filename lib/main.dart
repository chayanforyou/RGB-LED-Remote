import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rgbremote/config/app_theme.dart';
import 'package:rgbremote/services/settings_service.dart';
import 'package:rgbremote/views/remote_screen.dart';
import 'package:rgbremote/views/settings_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());
  unawaited(SettingsService.initialize());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      builder: (context, child) => Stack(
        children: [
          child!,
          DropdownAlert()
        ],
      ),
      home: RemoteScreen(),
      routes: {
        SettingsScreen.routeName: (_) => SettingsScreen(),
      },
    );
  }
}

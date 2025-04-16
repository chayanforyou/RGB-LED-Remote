import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dropdown_alert/dropdown_alert.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ads/applovin_ads.dart';
import 'application/navigation/app_router.dart';
import 'application/services/settings_service.dart';
import 'core/config/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  unawaited(MobileAds.instance.initialize());
  unawaited(AppLovinAds.instance.initialize());
  await SettingsService().initialize();
  
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
      initialRoute: Routes.remote,
      onGenerateRoute: generatedRoutes,
    );
  }
}

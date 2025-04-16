import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ad_service_manager.dart';

class BackPressHandler {
  static const String _exitCountKey = 'exitCount';
  static const int _triggerCount = 5;

  static Future<void> handleBackPress() async {
    final prefs = await SharedPreferences.getInstance();

    int exitCount = prefs.getInt(_exitCountKey) ?? 0;
    exitCount += 1;
    await prefs.setInt(_exitCountKey, exitCount);

    final bool shouldShowAd = exitCount % _triggerCount == 0;

    bool shouldExit = true;

    if (shouldShowAd) {
      shouldExit = await AdServiceManager.showInterstitialAd();
    }

    if (shouldExit) {
      SystemNavigator.pop();
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<bool> vibrationNotifier = ValueNotifier<bool>(true);

class PreferencesService {
  PreferencesService._();

  static const String keyVibration = "isVibrationEnabled";

  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _loadPreference();
  }

  static Future<void> _loadPreference() async {
    bool isVibrationEnabled = _prefs?.getBool(keyVibration) ?? true;
    vibrationNotifier.value = isVibrationEnabled;
  }

  static Future<void> satVibration(bool isEnabled) async {
    await _prefs?.setBool(keyVibration, isEnabled);
    vibrationNotifier.value = isEnabled;
  }
}

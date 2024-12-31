import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<AppSettings> settingsNotifier = ValueNotifier<AppSettings>(AppSettings());

class SettingsService {
  SettingsService._();

  static const String keyVibration = "isVibrationEnabled";
  static const String keyLight = "isLightEnabled";
  static const String keySound = "isSoundEnabled";
  static const String keySoundName= "soundFileName";

  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _loadSettings();
  }

  static Future<void> _loadSettings() async {
    bool isVibrationEnabled = _prefs?.getBool(keyVibration) ?? true;
    bool isLightEnabled = _prefs?.getBool(keyLight) ?? true;
    bool isSoundEnabled = _prefs?.getBool(keySound) ?? true;
    String? soundFileName = _prefs?.getString(keySoundName);

    settingsNotifier.value = settingsNotifier.value.copyWith(
      isVibrationEnabled: isVibrationEnabled,
      isLightEnabled: isLightEnabled,
      isSoundEnabled: isSoundEnabled,
      soundFileName: soundFileName,
    );
  }

  static Future<void> satVibration(bool isEnabled) async {
    await _prefs?.setBool(keyVibration, isEnabled);
    settingsNotifier.value = settingsNotifier.value.copyWith(
      isVibrationEnabled: isEnabled,
    );
  }

  static Future<void> setLight(bool isEnabled) async {
    await _prefs?.setBool(keyLight, isEnabled);
    settingsNotifier.value = settingsNotifier.value.copyWith(
      isLightEnabled: isEnabled,
    );
  }

  static Future<void> setSound(bool isEnabled) async {
    await _prefs?.setBool(keySound, isEnabled);
    settingsNotifier.value = settingsNotifier.value.copyWith(
      isSoundEnabled: isEnabled,
    );
  }

  static Future<void> setSoundName(String soundName) async {
    await _prefs?.setString(keySoundName, soundName);
    settingsNotifier.value = settingsNotifier.value.copyWith(
      soundFileName: soundName,
    );
  }
}

class AppSettings {
  bool isVibrationEnabled;
  bool isLightEnabled;
  bool isSoundEnabled;
  String? soundFileName;

  AppSettings({
    this.isVibrationEnabled = false,
    this.isLightEnabled = false,
    this.isSoundEnabled = false,
    this.soundFileName,
  });

  AppSettings copyWith({
    bool? isVibrationEnabled,
    bool? isLightEnabled,
    bool? isSoundEnabled,
    String? soundFileName,
  }) {
    return AppSettings(
      isVibrationEnabled: isVibrationEnabled ?? this.isVibrationEnabled,
      isLightEnabled: isLightEnabled ?? this.isLightEnabled,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      soundFileName: soundFileName ?? this.soundFileName,
    );
  }
}

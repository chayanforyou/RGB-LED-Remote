import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/preferences_keys.dart';
import '../../domain/entities/app_settings.dart';

abstract class SettingsDataSource {
  Future<AppSettings> getSettings();
  Future<void> saveSettings(AppSettings settings);
}

class SettingsDataSourceImpl implements SettingsDataSource {
  final SharedPreferences _prefs;

  SettingsDataSourceImpl(this._prefs);

  @override
  Future<AppSettings> getSettings() async {
    return AppSettings(
      isVibrationEnabled: _prefs.getBool(PreferencesKeys.vibration) ?? true,
      isLightEnabled: _prefs.getBool(PreferencesKeys.light) ?? true,
      isSoundEnabled: _prefs.getBool(PreferencesKeys.sound) ?? true,
      soundFileName: _prefs.getString(PreferencesKeys.soundName),
      remoteIndex: _prefs.getInt(PreferencesKeys.remoteIndex) ?? 0,
    );
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _prefs.setBool(PreferencesKeys.vibration, settings.isVibrationEnabled);
    await _prefs.setBool(PreferencesKeys.light, settings.isLightEnabled);
    await _prefs.setBool(PreferencesKeys.sound, settings.isSoundEnabled);
    await _prefs.setInt(PreferencesKeys.remoteIndex, settings.remoteIndex);
    if (settings.soundFileName != null) {
      await _prefs.setString(PreferencesKeys.soundName, settings.soundFileName!);
    }
  }
}

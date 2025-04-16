import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/settings_data_source.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';

class SettingsService {
  static final SettingsService _instance = SettingsService._internal();
  factory SettingsService() => _instance;
  SettingsService._internal();

  late final SettingsRepository _repository;
  final ValueNotifier<AppSettings> settingsNotifier = ValueNotifier<AppSettings>(AppSettings());

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _repository = SettingsRepositoryImpl(SettingsDataSourceImpl(prefs));
    await _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _repository.getSettings();
    settingsNotifier.value = settings;
  }

  Future<void> updateVibration(bool isEnabled) async {
    final newSettings = settingsNotifier.value.copyWith(isVibrationEnabled: isEnabled);
    await _repository.updateSettings(newSettings);
    settingsNotifier.value = newSettings;
  }

  Future<void> updateLight(bool isEnabled) async {
    final newSettings = settingsNotifier.value.copyWith(isLightEnabled: isEnabled);
    await _repository.updateSettings(newSettings);
    settingsNotifier.value = newSettings;
  }

  Future<void> updateSound(bool isEnabled) async {
    final newSettings = settingsNotifier.value.copyWith(isSoundEnabled: isEnabled);
    await _repository.updateSettings(newSettings);
    settingsNotifier.value = newSettings;
  }

  Future<void> updateSoundName(String soundName) async {
    final newSettings = settingsNotifier.value.copyWith(soundFileName: soundName);
    await _repository.updateSettings(newSettings);
    settingsNotifier.value = newSettings;
  }

  Future<void> updateRemote(int remoteIndex) async {
    final newSettings = settingsNotifier.value.copyWith(remoteIndex: remoteIndex);
    await _repository.updateSettings(newSettings);
    settingsNotifier.value = newSettings;
  }
}
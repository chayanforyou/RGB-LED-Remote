import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rgbremote/core/extensions/string_extensions.dart';

import '../../application/services/settings_service.dart';
import '../../core/config/app_color.dart';
import '../../core/config/app_text.dart';
import '../../core/constants/app_strings.dart';
import '../../domain/entities/app_settings.dart';
import '../../plugins/ir_sensor_plugin.dart';
import 'components/about_app.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const String routeName = "/settings";

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _settingsService = SettingsService();
  Map<String, int> _rawSoundList = {};

  @override
  void initState() {
    super.initState();
    _loadSoundList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.settingsTitle)),
      body: ValueListenableBuilder<AppSettings>(
        valueListenable: _settingsService.settingsNotifier,
        builder: (context, settings, child) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: const Text(AppStrings.vibrateOnTap),
                  subtitle: Text(
                    AppStrings.vibrateOnTapDesc,
                    style: AppTextStyle.kGS13W400,
                  ),
                  trailing: Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: settings.isVibrationEnabled,
                      onChanged: _toggleVibration,
                      activeColor: AppColors.kWhiteColor,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text(AppStrings.lightOnTap),
                  subtitle: Text(
                    AppStrings.lightOnTapDesc,
                    style: AppTextStyle.kGS13W400,
                  ),
                  trailing: Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: settings.isLightEnabled,
                      onChanged: _toggleLight,
                      activeColor: AppColors.kWhiteColor,
                    ),
                  ),
                ),
                ListTile(
                  title: const Text(AppStrings.soundOnTap),
                  subtitle: Text(
                    AppStrings.soundOnTapDesc,
                    style: AppTextStyle.kGS13W400,
                  ),
                  trailing: Transform.scale(
                    scale: 0.8,
                    child: Switch(
                      value: settings.isSoundEnabled,
                      onChanged: _toggleSound,
                      activeColor: AppColors.kWhiteColor,
                    ),
                  ),
                ),
                ListTile(
                  enabled: settings.isSoundEnabled,
                  title: const Text(AppStrings.tapSound),
                  trailing: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: settings.soundFileName,
                      borderRadius: BorderRadius.circular(12),
                      style: TextStyle(
                        color: AppColors.kWhiteColor.withAlpha(200),
                      ),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.kGreyColor.withAlpha(0xAA),
                        size: 18,
                      ),
                      onChanged: settings.isSoundEnabled ? _setSoundFile : null,
                      items: _rawSoundList.keys.map<DropdownMenuItem<String>>((String fileName) {
                        return DropdownMenuItem<String>(
                          value: fileName,
                          child: Text(fileName.formatName()),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
                child!,
              ],
            ),
          );
        },
        child: const AboutApp(),
      ),
    );
  }

  Future<void> _loadSoundList() async {
    try {
      final rawSoundList = await IrSensorPlugin.rawSoundList();
      setState(() => _rawSoundList = rawSoundList);

      final settings = _settingsService.settingsNotifier.value;
      if (settings.soundFileName == null && _rawSoundList.isNotEmpty) {
        await _settingsService.updateSoundName(_rawSoundList.keys.first);
      }
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }

  Future<void> _toggleVibration(bool isEnabled) async {
    await _settingsService.updateVibration(isEnabled);
  }

  Future<void> _toggleLight(bool isEnabled) async {
    await _settingsService.updateLight(isEnabled);
  }

  Future<void> _toggleSound(bool isEnabled) async {
    await _settingsService.updateSound(isEnabled);
  }

  Future<void> _setSoundFile(String? fileName) async {
    if (fileName != null) {
      await _settingsService.updateSoundName(fileName);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rgbremote/extensions/string_extensions.dart';
import 'package:rgbremote/plugin/ir_sensor_plugin.dart';
import 'package:rgbremote/services/settings_service.dart';
import 'package:rgbremote/config/app_color.dart';
import 'package:rgbremote/config/app_text.dart';
import 'package:rgbremote/views/components/about_app.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const String routeName = "/settings";

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late AppSettings _settings;
  Map<String, int> _rawSoundList = {};

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
            ListTile(
              title: Text("Vibrate on Tap"),
              subtitle: Text(
                "Provides a subtle vibration when a remote button is pressed",
                style: AppTextStyle.kGS13W400,
              ),
              trailing: Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: _settings.isVibrationEnabled,
                  onChanged: _toggleVibration,
                  activeColor: AppColors.kWhiteColor,
                ),
              ),
            ),
            ListTile(
              title: Text("Light on Tap"),
              subtitle: Text(
                "Show the IR emitting light to flash briefly when a button is pressed",
                style: AppTextStyle.kGS13W400,
              ),
              trailing: Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: _settings.isLightEnabled,
                  onChanged: _toggleLight,
                  activeColor: AppColors.kWhiteColor,
                ),
              ),
            ),
            ListTile(
              title: Text("Sound on Tap"),
              subtitle: Text(
                "Activate sound feedback when a remote button is pressed",
                style: AppTextStyle.kGS13W400,
              ),
              trailing: Transform.scale(
                scale: 0.8,
                child: Switch(
                  value: _settings.isSoundEnabled,
                  onChanged: _toggleSound,
                  activeColor: AppColors.kWhiteColor,
                ),
              ),
            ),
            ListTile(
              enabled: _settings.isSoundEnabled,
              title: Text("Tap Sound"),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _settings.soundFileName,
                  borderRadius: BorderRadius.circular(12),
                  style: TextStyle(
                    color: AppColors.kWhiteColor.withAlpha(200),
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.kGreyColor.withAlpha(0xAA),
                    size: 18,
                  ),
                  onChanged: _settings.isSoundEnabled ? _setSoundFile : null,
                  items: _rawSoundList.keys
                      .map<DropdownMenuItem<String>>((String fileName) {
                    return DropdownMenuItem<String>(
                      value: fileName,
                      child: Text(fileName.formatName()),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 50),
            AboutApp(),
          ],
        ),
      ),
    );
  }

  Future<void> _loadSettings() async {
    _settings = settingsNotifier.value;

    try {
      final rawSoundList = await IrSensorPlugin.rawSoundList();
      setState(() => _rawSoundList = rawSoundList);

      if (_settings.soundFileName == null && _rawSoundList.isNotEmpty) {
        _setSoundFile(_rawSoundList.keys.first);
      }
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }

  void _toggleVibration(bool isEnabled) async {
    await SettingsService.satVibration(isEnabled);
    setState(() {
      _settings.isVibrationEnabled = isEnabled;
    });
  }

  void _toggleLight(bool isEnabled) async {
    await SettingsService.setLight(isEnabled);
    setState(() {
      _settings.isLightEnabled = isEnabled;
    });
  }

  void _toggleSound(bool isEnabled) async {
    await SettingsService.setSound(isEnabled);
    setState(() {
      _settings.isSoundEnabled = isEnabled;
    });
  }

  void _setSoundFile(String? fileName) async {
    await SettingsService.setSoundName(fileName!);
    setState(() {
      _settings.soundFileName = fileName;
    });
  }
}

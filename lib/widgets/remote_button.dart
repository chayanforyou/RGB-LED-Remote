import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:material_neumorphic/material_neumorphic.dart';
import 'package:rgbremote/config/app_color.dart';
import 'package:rgbremote/ir_data//pronto_data.dart';
import 'package:rgbremote/plugin/ir_sensor_plugin.dart';
import 'package:rgbremote/services/settings_service.dart';
import 'package:rgbremote/utils/hex_color.dart';
import 'package:rgbremote/views/remote_screen.dart';

ValueNotifier<void> buttonPressedNotifier = ValueNotifier<void>(null);

class RemoteButton extends StatelessWidget {
  final int index;
  final TextStyle? labelStyle;

  const RemoteButton(
    this.index, {
    super.key,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final data = prontoData[index];
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ValueListenableBuilder<AppSettings>(
        valueListenable: settingsNotifier,
        builder: (context, settings, child) {
          return NeumorphicButton(
            onPressed: () async {
              try {
                await IrSensorPlugin.transmitString(pattern: data["pattern"]);

                if (settings.isLightEnabled) lightEffectController.add(data["name"]);
                if (settings.isSoundEnabled) await IrSensorPlugin.playSound(soundName: settings.soundFileName);
                if (settings.isVibrationEnabled) await IrSensorPlugin.vibrate();
              } on PlatformException catch (e) {
                AlertController.show("Error", "${e.message}", TypeAlert.error);
              }
            },
            padding: EdgeInsets.zero,
            provideHapticFeedback: false,
            style: NeumorphicStyle(
              color: HexColor(data["color"]),
              boxShape: NeumorphicBoxShape.circle(),
              lightSource: LightSource.topLeft,
              depth: 3,
              intensity: 1,
              surfaceIntensity: 0.5,
              shape: NeumorphicShape.convex,
              shadowLightColor: AppColors.kShadowLightColor,
              shadowDarkColor: AppColors.kShadowDarkColor,
              border: NeumorphicBorder(
                color: AppColors.kButtonBorderColor,
                width: 1,
              ),
            ),
            child: SizedBox(
              width: 50,
              height: 50,
              child: _buildChild(data),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChild(Map data) {
    return Center(
      child: labelStyle != null
          ? Text(data["name"], style: labelStyle)
          : Icon(data["icon"], color: AppColors.kBlackColor),
    );
  }
}

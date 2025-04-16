import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dropdown_alert/alert_controller.dart';
import 'package:flutter_dropdown_alert/model/data_alert.dart';
import 'package:material_neumorphic/material_neumorphic.dart';

import '../../application/services/remote_assist_service.dart';
import '../../application/services/settings_service.dart';
import '../../core/config/app_color.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/hex_color.dart';
import '../../data/models/pronto_command.dart';
import '../../domain/entities/app_settings.dart';
import '../../plugins/ir_sensor_plugin.dart';
import '../screens/remote_screen.dart';

class RemoteButton extends StatefulWidget {
  final ProntoCommand command;
  final TextStyle? labelStyle;

  const RemoteButton(
    this.command, {
    super.key,
    this.labelStyle,
  });

  @override
  State<RemoteButton> createState() => _RemoteButtonState();
}

class _RemoteButtonState extends State<RemoteButton> {
  final _settingsService = SettingsService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: ValueListenableBuilder<AppSettings>(
        valueListenable: _settingsService.settingsNotifier,
        builder: (context, settings, child) {
          return NeumorphicButton(
            onPressed: () async {
              try {
                if (await IrSensorPlugin.hasIrEmitter) {
                  if (settings.isLightEnabled) eventController.add(EventState.lightEffect);
                  if (settings.isSoundEnabled) await IrSensorPlugin.playSound(soundName: settings.soundFileName);
                  if (settings.isVibrationEnabled) await IrSensorPlugin.vibrate();
                  await IrSensorPlugin.transmitString(pattern: widget.command.pattern);
                } else {
                  AlertController.show(
                    AppStrings.irBlasterUnavailableTitle,
                    AppStrings.irBlasterUnavailableMessage,
                    TypeAlert.error,
                  );
                }
              } on PlatformException catch (e) {
                AlertController.show(AppStrings.error, "${e.message}", TypeAlert.error);
              }

              if (await IrSensorPlugin.hasIrEmitter) {
                await RemoteAssistPromptService.maybeShowPrompt(onPrompt: () {
                  eventController.add(EventState.showPrompt);
                });
              }
            },
            padding: EdgeInsets.zero,
            provideHapticFeedback: false,
            style: NeumorphicStyle(
              color: HexColor(widget.command.color),
              boxShape: NeumorphicBoxShape.circle(),
              lightSource: LightSource.topLeft,
              depth: 3,
              intensity: 1,
              surfaceIntensity: 0.5,
              shape: NeumorphicShape.convex,
              shadowLightColor: AppColors.kShadowLightColor,
              shadowDarkColor: AppColors.kShadowDarkColor,
              border: NeumorphicBorder(color: AppColors.kButtonBorderColor, width: 1),
            ),
            child: SizedBox(
              width: 50,
              height: 50,
              child: _buildChild(widget.command),
            ),
          );
        },
      ),
    );
  }

  Widget _buildChild(ProntoCommand command) {
    return Center(
      child: widget.labelStyle != null
          ? Text(command.name, style: widget.labelStyle)
          : Icon(command.icon, color: AppColors.kBlackColor),
    );
  }
}

import 'dart:async';

import 'package:flutter/services.dart';

class IrSensorPlugin {
  static const MethodChannel _channel = MethodChannel('ir_sensor_plugin');

  /// Check whether the device has an infrared emitter.
  /// Returns `"true"` if the device has an infrared emitter, else `"false"` .
  static Future<bool> get hasIrEmitter async {
    return await _channel.invokeMethod('hasIrEmitter');
  }

  /// Query the infrared transmitter's supported carrier frequencies in `Hertz`.
  static Future<String> get getCarrierFrequencies async {
    return await _channel.invokeMethod('getCarrierFrequencies');
  }

  /// Change the frequency with which it is transmitted. Default is 38020 Hz
  static Future<String> setFrequencies(int newFrequency) async {
    return await _channel.invokeMethod('setFrequency', {"setFrequency": newFrequency});
  }

  /// It transmits an infrared pattern, return a String "Emitting" if there was
  /// no problem in the process.
  ///
  /// This method receives a String
  ///
  /// The value [pattern] has to be a string that contains the behavior in `HEX`, example:
  /// `TV_POWER_HEX = "0000 006d 0022 0003 00a9 00a8 0015 003f 0015 003f 0015 003f
  /// 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f 0015 003f 0015
  /// 003f 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 003f
  /// 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0015 0040 0015
  /// 0015 0015 003f 0015 003f 0015 003f 0015 003f 0015 003f 0015 003f 0015 0702
  /// 00a9 00a8 0015 0015 0015 0e6e"`;
  static Future<String> transmitString({required String pattern}) async {
    return await _channel.invokeMethod('codeForEmitter', {"codeForEmitter": pattern});
  }

  /// This method receives a Int List
  ///
  /// var SAMSUNG_POWER = [169,168,21,63,21,63,21,63,21,21,21,21,21,21,
  /// 21,21,21,21,21,63,21,63,21,63,21,21,21,21,21,21,21,21,21,21,21,21,21,63,21,
  /// 21,21,21,21,21,21,21,21,21,21,21,21,64,21,21,21,63,21,63,21,63,21,63,21,63,
  /// 21,63,21,1794,169,168,21,21,21,3694];

  static Future<String> transmitListInt({required List<int> list}) async {
    return await _channel.invokeMethod('transmitListInt', {"transmitListInt": list});
  }

  /// This method is for making vibration
  static Future<void> vibrate() async {
    return await _channel.invokeMethod('vibrate');
  }

  static Future<Map<String, int>> rawSoundList() async {
    final rawSoundList = await _channel.invokeMethod('rawSoundList');
    return (rawSoundList as Map<Object?, Object?>).cast<String, int>();
  }

  /// This method is for playing sound
  static Future<void> playSound({required String? soundName}) async {
    return await _channel.invokeMethod('playSound', {"soundName": soundName} );
  }
}
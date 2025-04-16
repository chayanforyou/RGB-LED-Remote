import 'package:flutter/material.dart';

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }

    final hexNum = int.parse(hexColor, radix: 16);

    return (hexNum == 0) ? 0xff000000 : hexNum;
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class ColorToHex extends Color {
  static int _floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }

  /// convert material colors to hex color
  static int _convertColorTHex(Color color) {
    return _floatToInt8(color.a) << 24 |
        _floatToInt8(color.r) << 16 |
        _floatToInt8(color.g) << 8 |
        _floatToInt8(color.b) << 0;
  }

  ColorToHex(final Color color) : super(_convertColorTHex(color));
}

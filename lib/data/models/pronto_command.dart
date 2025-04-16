import 'package:flutter/widgets.dart';

class ProntoCommand {
  final String name;
  final String pattern;
  final String color;
  final IconData? icon;

  ProntoCommand({
    required this.name,
    required this.pattern,
    required this.color,
    this.icon,
  });
}

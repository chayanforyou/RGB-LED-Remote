import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Hyperlink extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final String url;
  final int? maxLines;

  const Hyperlink(
    this.text,
    this.url, {
    super.key,
    this.textAlign,
    this.overflow,
    this.style = const TextStyle(),
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await launchUrlString(
          url,
          mode: LaunchMode.externalApplication,
        );
      },
      child: Text(
        text,
        overflow: overflow,
        maxLines: maxLines,
        style: style.copyWith(color: Colors.blue),
        textAlign: textAlign,
      ),
    );
  }
}

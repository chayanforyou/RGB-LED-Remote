import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rgbremote/config/app_text.dart';
import 'package:rgbremote/widgets/hyper_link.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({super.key});

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  String _appVersion = "";

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = packageInfo.version;
    });
  }

  @override
  void initState() {
    _getAppVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Made with ❤️ by Chayan",
          textAlign: TextAlign.center,
          style: AppTextStyle.kWS14W400,
        ),
        Text(
          'Version: v$_appVersion',
          textAlign: TextAlign.center,
          style: AppTextStyle.kGS13W400,
        ),
        Hyperlink(
          "github.com/chayanforyou/RGB-LED-Remote",
          "https://github.com/chayanforyou/RGB-LED-Remote",
        ),
      ],
    );
  }
}

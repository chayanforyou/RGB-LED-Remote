import 'package:applovin_max/applovin_max.dart';

class AppLovinAds {
  AppLovinAds._();

  static final AppLovinAds _instance = AppLovinAds._();

  /// Shared instance to initialize the AppLovinMAX SDK.
  static AppLovinAds get instance => _instance;

  Future<MaxConfiguration?> initialize() {
    // AppLovinMAX.setVerboseLogging(true);
    return AppLovinMAX.initialize("UvQFGrf4TM7U8IoyVwE8OsCqARb6KaCOUV2WeLCTa1AXGg67UCwdlCR0SXXP7Pq3ETkDLIIdTipqqoIuknkzrh");
  }
}

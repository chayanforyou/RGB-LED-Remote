import 'package:easy_audience_network/easy_audience_network.dart';

class FacebookAds {
  FacebookAds._();

  static final FacebookAds _instance = FacebookAds._();

  /// Shared instance to initialize the Facebook SDK.
  static FacebookAds get instance => _instance;

  Future<bool?> initialize() {
    return EasyAudienceNetwork.init(
      testMode: false,
      iOSAdvertiserTrackingEnabled: true,
    );
  }
}

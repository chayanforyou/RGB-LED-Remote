import '../../ads/applovin_ad_manager.dart';
import '../../ads/google_ad_manager.dart';

class AdServiceManager {
  /// Load Google ad first, fallback to AppLovin if fails
  static void loadInterstitialWithFallback() {
    GoogleAdManager().loadInterstitialAd(
      onAdLoadError: () {
        AppLovinAdManager().loadInterstitialAd();
      },
    );
  }

  /// Show the first available interstitial ad (Google > AppLovin)
  static Future<bool> showInterstitialAd() async {
    if (GoogleAdManager().isAdLoaded()) {
      return await GoogleAdManager().showInterstitialAd();
    } else {
      return await AppLovinAdManager().showInterstitialAd();
    }
  }
}

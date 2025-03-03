import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GoogleAdManager {
  InterstitialAd? _interstitialAd;
  final String _adUnitId = 'ca-app-pub-3224119074707344/4058225198';

  static final GoogleAdManager _instance = GoogleAdManager._internal();

  factory GoogleAdManager() {
    return _instance;
  }

  GoogleAdManager._internal();

  bool isAdLoaded() {
    return _interstitialAd != null;
  }

  /// Load an interstitial ad
  void loadInterstitialAd({VoidCallback? onAdLoadError}) {
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
          onAdLoadError?.call();
        },
      ),
    );
  }

  /// Show interstitial ad
  Future<bool> showInterstitialAd() {
    final completer = Completer<bool>();

    if (_interstitialAd != null) {
      _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (Ad ad) {
          ad.dispose();
          completer.complete(true);
        },
        onAdFailedToShowFullScreenContent: (Ad ad, AdError err) {
          ad.dispose();
          completer.complete(true);
        },
      );

      _interstitialAd?.show();
    } else {
      completer.complete(true);
    }

    return completer.future;
  }
}

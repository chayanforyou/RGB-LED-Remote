import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../core/constants/ad_unit_ids.dart';

class GoogleAdManager {
  InterstitialAd? _interstitialAd;

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
      adUnitId: AdUnitIds.googleInterstitial,
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

    final ad = _interstitialAd;
    if (ad != null) {
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (Ad ad) {
          ad.dispose();
          completer.complete(true);
        },
        onAdFailedToShowFullScreenContent: (Ad ad, AdError err) {
          ad.dispose();
          completer.complete(true);
        },
      );

      ad.show();
    } else {
      completer.complete(true);
    }

    return completer.future;
  }
}

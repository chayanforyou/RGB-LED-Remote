import 'dart:async';

import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/widgets.dart';

import '../core/constants/ad_unit_ids.dart';

class AppLovinAdManager {
  bool _isInterstitialLoaded = false;

  static final AppLovinAdManager _instance = AppLovinAdManager._internal();

  factory AppLovinAdManager() {
    return _instance;
  }

  AppLovinAdManager._internal();

  bool isAdLoaded() {
    return _isInterstitialLoaded;
  }

  /// Load an banner ad
  Widget loadBannerAd(Size adaptiveSize) {
    return MaxAdView(
      adUnitId: AdUnitIds.appLovinBanner,
      adFormat: AdFormat.banner,
      width: adaptiveSize.width,
      height: adaptiveSize.height,
    );
  }

  /// Load an interstitial ad
  void loadInterstitialAd({VoidCallback? onAdLoadError}) {
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        _isInterstitialLoaded = true;
      },
      onAdLoadFailedCallback: (_, __) {
        _isInterstitialLoaded = false;
        onAdLoadError?.call();
      },
      onAdHiddenCallback: (_) {},
      onAdDisplayedCallback: (MaxAd ad) {},
      onAdDisplayFailedCallback: (MaxAd ad, MaxError error) {},
      onAdClickedCallback: (MaxAd ad) {},
    ));

    AppLovinMAX.loadInterstitial(AdUnitIds.appLovinInterstitial);
  }

  /// Show interstitial ad
  Future<bool> showInterstitialAd() {
    final completer = Completer<bool>();

    if (_isInterstitialLoaded) {
      AppLovinMAX.setInterstitialListener(InterstitialListener(
        onAdLoadedCallback: (ad) {},
        onAdLoadFailedCallback: (_, __) {},
        onAdHiddenCallback: (_) {
          completer.complete(true);
        },
        onAdDisplayedCallback: (MaxAd ad) {},
        onAdDisplayFailedCallback: (MaxAd ad, MaxError error) {},
        onAdClickedCallback: (MaxAd ad) {},
      ));

      AppLovinMAX.showInterstitial(AdUnitIds.appLovinInterstitial);
    } else {
      completer.complete(true);
    }

    return completer.future;
  }
}

import 'dart:async';

import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/widgets.dart';

class AppLovinAdManager {
  bool _isInterstitialLoaded = false;
  final String _interstitialAdUnitId = 'e2a564b95db03499';
  final String _bannerAdUnitId = 'e70aaba2e5f7fd75';

  static final AppLovinAdManager _instance = AppLovinAdManager._internal();

  factory AppLovinAdManager() {
    return _instance;
  }

  AppLovinAdManager._internal();

  void consentFlow() {
    AppLovinMAX.setTermsAndPrivacyPolicyFlowEnabled(true);
    AppLovinMAX.setPrivacyPolicyUrl('https://chayanforyou.github.io/privacy');
    AppLovinMAX.setTermsOfServiceUrl('https://chayanforyou.github.io/terms');
  }

  bool isAdLoaded() {
    return _isInterstitialLoaded;
  }

  /// Load an banner ad
  Widget loadBannerAd(Size adaptiveSize) {
    return MaxAdView(
      adUnitId: _bannerAdUnitId,
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

    AppLovinMAX.loadInterstitial(_interstitialAdUnitId);
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

      AppLovinMAX.showInterstitial(_interstitialAdUnitId);
    } else {
      completer.complete(true);
    }

    return completer.future;
  }
}

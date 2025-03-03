import 'dart:async';

import 'package:easy_audience_network/easy_audience_network.dart';
import 'package:flutter/widgets.dart';

class FacebookAdManager {
  InterstitialAd? _interstitialAd;
  final String _adUnitId = '872718798313323_872721628313040';

  static final FacebookAdManager _instance = FacebookAdManager._internal();

  factory FacebookAdManager() {
    return _instance;
  }

  FacebookAdManager._internal();

  bool isAdLoaded() {
    return _interstitialAd != null;
  }

  /// Load an banner ad
  Widget loadBannerAd() {
    return BannerAd(
      placementId: "872718798313323_872720748313128",
      bannerSize: BannerSize.STANDARD,
      listener: BannerAdListener(
        onLoaded: () {
          // print('banner ad loaded');
        },
        onError: (code, message) {
          // print('banner ad error\ncode = $code\nmessage = $message');
        },
      ),
    );
  }

  /// Load an interstitial ad
  void loadInterstitialAd({VoidCallback? onAdLoadError}) {
    _interstitialAd = InterstitialAd(_adUnitId);
    _interstitialAd?.listener = InterstitialAdListener(
      onLoaded: () {
        // print('interstitial ad loaded');
      },
      onError: (code, message) {
        // print('interstitial ad error\ncode = $code\nmessage = $message');
        _interstitialAd = null;
        onAdLoadError?.call();
      },
    );
    _interstitialAd?.load();
  }

  /// Show interstitial ad
  Future<bool> showInterstitialAd() {
    final completer = Completer<bool>();

    if (_interstitialAd != null) {
      _interstitialAd?.listener = InterstitialAdListener(
        onDismissed: () {
          _interstitialAd?.destroy();
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

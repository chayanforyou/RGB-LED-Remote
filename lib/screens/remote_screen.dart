import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rgbremote/widgets/banner_ad_widget.dart';
import 'package:rgbremote/screens/settings_screen.dart';
import 'package:rgbremote/utils/app_color.dart';
import 'package:rgbremote/utils/app_text.dart';
import 'package:rgbremote/utils/consent_manager.dart';
import 'package:rgbremote/widgets/remote_button.dart';

class RemoteScreen extends StatefulWidget {
  const RemoteScreen({super.key});

  @override
  State<RemoteScreen> createState() => _RemoteScreenState();
}

class _RemoteScreenState extends State<RemoteScreen> {
  InterstitialAd? _interstitialAd;
  final _consentManager = ConsentManager();
  final String _adUnitId = 'ca-app-pub-3224119074707344/4058225198';

  @override
  void initState() {
    super.initState();

    _consentManager.gatherConsent((consentGatheringError) {
      if (consentGatheringError != null) {
        debugPrint("${consentGatheringError.errorCode}: ${consentGatheringError.message}");
      }

      _loadAppExitAd();
    });

    _loadAppExitAd();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldPop = await _showAppExitAds();
        if (mounted && shouldPop == true) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SettingsScreen.routeName);
              },
              icon: Icon(Icons.settings),
            ),
          ],
        ),
        body: Center(
          child: Card(
            color: AppColor.kRemoteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(color: AppColor.kBorderColor, width: 10),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RemoteButton(0),
                      RemoteButton(1),
                      RemoteButton(2, labelStyle: AppTextStyle.kWS15W500),
                      RemoteButton(3, labelStyle: AppTextStyle.kWS15W500),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RemoteButton(4, labelStyle: AppTextStyle.kWS15W500),
                      RemoteButton(5, labelStyle: AppTextStyle.kWS15W500),
                      RemoteButton(6, labelStyle: AppTextStyle.kWS15W500),
                      RemoteButton(7, labelStyle: AppTextStyle.kBS15W500),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RemoteButton(12),
                      RemoteButton(16),
                      RemoteButton(20),
                      RemoteButton(8, labelStyle: AppTextStyle.kWS10W500),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RemoteButton(13),
                      RemoteButton(17),
                      RemoteButton(21),
                      RemoteButton(9, labelStyle: AppTextStyle.kWS10W500),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RemoteButton(14),
                      RemoteButton(18),
                      RemoteButton(22),
                      RemoteButton(10, labelStyle: AppTextStyle.kWS10W500),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RemoteButton(15),
                      RemoteButton(19),
                      RemoteButton(23),
                      RemoteButton(11, labelStyle: AppTextStyle.kWS10W500),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BannerAdWidget(),
      ),
    );
  }

  /// Loads an interstitial ad.
  void _loadAppExitAd() async {
    var canRequestAds = await _consentManager.canRequestAds();
    if (!canRequestAds) {
      return;
    }

    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd = null;
        },
      ),
    );
  }

  /// Show interstitial ad.
  Future<bool> _showAppExitAds() {
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

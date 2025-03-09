import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rgbremote/ads/applovin_ad_manager.dart';
import 'package:rgbremote/config/app_color.dart';
import 'package:rgbremote/config/app_text.dart';
import 'package:rgbremote/ads/google_ad_manager.dart';
import 'package:rgbremote/utils/consent_manager.dart';
import 'package:rgbremote/views/settings_screen.dart';
import 'package:rgbremote/ads/widgets/banner_ad_widget.dart';
import 'package:rgbremote/widgets/remote_button.dart';
import 'package:rgbremote/widgets/ir_light_effect.dart';

final StreamController<String> lightEffectController = StreamController.broadcast();

class RemoteScreen extends StatefulWidget {
  const RemoteScreen({super.key});

  @override
  State<RemoteScreen> createState() => _RemoteScreenState();
}

class _RemoteScreenState extends State<RemoteScreen> with SingleTickerProviderStateMixin {
  final ConsentManager _consentManager = ConsentManager();

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late StreamSubscription<String> _subscription;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _subscription = lightEffectController.stream.listen((_) {
      _animationController.forward();
    });

    _consentManager.gatherConsent((consentGatheringError) {
      if (consentGatheringError != null) {
        debugPrint("${consentGatheringError.errorCode}: ${consentGatheringError.message}");
      }

      GoogleAdManager().loadInterstitialAd(onAdLoadError: () {
        // In case of failed to load google ads, load applovin ads instead
        // AppLovinAdManager().consentFlow();
        AppLovinAdManager().loadInterstitialAd();
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        bool isGoogleAdLoaded = GoogleAdManager().isAdLoaded();
        final shouldPop = isGoogleAdLoaded
            ? await GoogleAdManager().showInterstitialAd()
            : await AppLovinAdManager().showInterstitialAd();
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
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (BuildContext context, Widget? child) {
                    return Opacity(
                      opacity: _opacityAnimation.value,
                      child: child,
                    );
                  },
                  child: IRLightEffect(),
                ),
                Card(
                  color: AppColors.kRemoteColor,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(color: AppColors.kBorderColor, width: 8),
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
              ],
            ),
          ),
        ),
        bottomNavigationBar: BannerAdWidget(),
      ),
    );
  }
}

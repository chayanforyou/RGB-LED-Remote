import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rgbremote/ads/applovin_ad_manager.dart';
import 'package:rgbremote/core/utils/consent_manager.dart';

import '../../core/constants/ad_unit_ids.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  final _consentManager = ConsentManager();
  BannerAd? _googleBannerAd;
  Widget? _applovinBannerAd;
  bool _adLoaded = false;

  Widget get _adWidget {
    if (_applovinBannerAd != null) return _applovinBannerAd!;
    if (_googleBannerAd != null) return AdWidget(ad: _googleBannerAd!);
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(height: 50, child: _adWidget),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadAd());
  }

  @override
  void dispose() {
    _googleBannerAd?.dispose();
    super.dispose();
  }

  /// Loads a banner ad.
  void _loadAd() async {
    if (_adLoaded) return;

    final canRequestAds = await _consentManager.canRequestAds();
    if (!canRequestAds || !mounted) return;

    _adLoaded = true;

    final adSize = await _getAdSize(context);
    final bannerAd = BannerAd(
      size: adSize,
      adUnitId: AdUnitIds.googleBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _googleBannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          // In case of failed to load google ads, load applovin ads instead
          if (mounted && _applovinBannerAd == null) {
            final size = Size(adSize.width.toDouble(), adSize.height.toDouble());
            setState(() {
              _applovinBannerAd = AppLovinAdManager().loadBannerAd(size);
            });
          }
        },
      ),
    );

    bannerAd.load();
  }

  Future<AdSize> _getAdSize(BuildContext context) async {
    final AdSize? adaptiveSize = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.sizeOf(context).width.truncate(),
    );

    if (adaptiveSize == null) {
      return AdSize.banner;
    } else {
      return adaptiveSize;
    }
  }
}

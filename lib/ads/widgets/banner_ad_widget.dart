import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rgbremote/ads/facebook_ad_manager.dart';
import 'package:rgbremote/utils/consent_manager.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  final _consentManager = ConsentManager();
  BannerAd? _googleBannerAd;
  Widget? _facebookBannerAd;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      // child: SizedBox(
      //   width: _bannerAd?.size.width.toDouble() ?? double.infinity,
      //   height: _bannerAd?.size.height.toDouble() ?? 50,
      //   child: _bannerAd == null ? SizedBox() : AdWidget(ad: _bannerAd!),
      // ),
      child: _facebookBannerAd != null
          ? _facebookBannerAd!
          : SizedBox(
              width: _googleBannerAd?.size.width.toDouble() ?? double.infinity,
              height: _googleBannerAd?.size.height.toDouble() ?? 50,
              child: _googleBannerAd == null ? SizedBox() : AdWidget(ad: _googleBannerAd!),
            ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  @override
  void dispose() {
    _googleBannerAd?.dispose();
    super.dispose();
  }

  /// Loads a banner ad.
  void _loadAd() async {
    var canRequestAds = await _consentManager.canRequestAds();
    if (!canRequestAds) return;

    if (!mounted) return;

    final adSize = await _getAdSize(context);
    final bannerAd = BannerAd(
      size: adSize,
      adUnitId: "ca-app-pub-3224119074707344/1274582513",
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
          // In case of failed to load google ads, load facebook ads instead
          setState(() {
            _facebookBannerAd = FacebookAdManager().loadBannerAd();
          });
        },
      ),
    );

    bannerAd.load();
  }

  Future<AdSize> _getAdSize(BuildContext context) async {
    final AdSize? adaptiveSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(MediaQuery.sizeOf(context).width.truncate());

    if (adaptiveSize == null) {
      return AdSize.banner;
    } else {
      return adaptiveSize;
    }
  }
}

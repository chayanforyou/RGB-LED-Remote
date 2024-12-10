import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:rgbremote/utils/consent_manager.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  final _consentManager = ConsentManager();
  final String _adUnitId = 'ca-app-pub-3224119074707344/1274582513';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: _bannerAd?.size.width.toDouble() ?? double.infinity,
        height: _bannerAd?.size.height.toDouble() ?? 50,
        child: _bannerAd == null ? SizedBox() : AdWidget(ad: _bannerAd!),
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
    _bannerAd?.dispose();
    super.dispose();
  }

  /// Loads a banner ad.
  void _loadAd() async {
    var canRequestAds = await _consentManager.canRequestAds();
    if (!canRequestAds) return;

    if (!mounted) return;

    final bannerAd = BannerAd(
      size: await _getAdSize(context),
      adUnitId: _adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
        },
      ),
    );

    bannerAd.load();
  }

  Future<AdSize> _getAdSize(BuildContext context) async {
    final AdSize? adaptiveSize =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
            MediaQuery.sizeOf(context).width.truncate());

    if (adaptiveSize == null) {
      return AdSize.banner;
    } else {
      return adaptiveSize;
    }
  }
}

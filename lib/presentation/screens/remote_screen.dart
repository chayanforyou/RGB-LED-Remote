import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:rgbremote/core/config/app_color.dart';
import 'package:rgbremote/presentation/screens/components/tooltip_widget.dart';

import '../../ads/widgets/banner_ad_widget.dart';
import '../../application/services/ad_service_manager.dart';
import '../../application/services/back_press_handler.dart';
import '../../application/services/settings_service.dart';
import '../../core/utils/consent_manager.dart';
import '../../data/models/remote_config.dart';
import '../../domain/entities/app_settings.dart';
import '../../resources/pronto_data.dart';
import '../widgets/ir_light_effect.dart';
import 'components/remote_ui.dart';
import 'settings_screen.dart';

final StreamController<EventState> eventController = StreamController.broadcast();

enum EventState {
  lightEffect,
  showPrompt,
}

class RemoteScreen extends StatefulWidget {
  const RemoteScreen({super.key});

  @override
  State<RemoteScreen> createState() => _RemoteScreenState();
}

class _RemoteScreenState extends State<RemoteScreen> with SingleTickerProviderStateMixin {
  final SettingsService _settingsService = SettingsService();
  final ConsentManager _consentManager = ConsentManager();
  final JustTheController _tooltipController = JustTheController();

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late StreamSubscription<EventState> _subscription;

  late int _selectedRemote;

  final List<RemoteConfig> _remotes = [
    RemoteConfig(name: "Remote 1", ui: RemoteUI(prontoData: getProntoData(ProntoDataType.type1))),
    RemoteConfig(name: "Remote 2", ui: RemoteUI(prontoData: getProntoData(ProntoDataType.type2))),
  ];

  @override
  void initState() {
    super.initState();
    _selectedRemote = _settingsService.settingsNotifier.value.remoteIndex;

    _initializeAnimationController();
    _initializeConsentAndAds();
  }

  void _initializeAnimationController() {
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

    _subscription = eventController.stream.listen((event) {
      switch (event) {
        case EventState.lightEffect:
          _animationController.forward();
          break;
        case EventState.showPrompt:
          _tooltipController.showTooltip(immediately: true);
      }
    });
  }

  void _initializeConsentAndAds() {
    _consentManager.gatherConsent((consentGatheringError) {
      if (consentGatheringError != null) {
        debugPrint("${consentGatheringError.errorCode}: ${consentGatheringError.message}");
      }

      AdServiceManager.loadInterstitialWithFallback();
    });
  }

  Future<void> _updateSelectedRemote(int index) async {
    _selectedRemote = index.clamp(0, _remotes.length - 1);
    await _settingsService.updateRemote(_selectedRemote);
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
        await BackPressHandler.handleBackPress();
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
        body: ValueListenableBuilder<AppSettings>(
          valueListenable: _settingsService.settingsNotifier,
          builder: (context, settings, child) {
            return Column(
              children: [
                _buildRemoteSelector(),
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      SliverFillRemaining(
                        hasScrollBody: false,
                        fillOverscroll: true,
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
                            // Render remote ui
                            _remotes[_selectedRemote].ui,
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: BannerAdWidget(),
      ),
    );
  }

  Widget _buildRemoteSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_left),
          onPressed: _selectedRemote > 0
              ? () => _updateSelectedRemote(_selectedRemote - 1)
              : null,
        ),
        JustTheTooltip(
          controller: _tooltipController,
          preferredDirection: AxisDirection.up,
          backgroundColor: AppColors.kWhiteColor,
          isModal: true,
          showDuration: const Duration(seconds: 10),
          margin: const EdgeInsets.all(10),
          borderRadius: BorderRadius.circular(8),
          content: TooltipWidget(
            onDismiss: () {
              _tooltipController.hideTooltip(immediately: true);
            },
          ),
          child: Text(
            "${_remotes[_selectedRemote].name}/${_remotes.length}",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_right),
          onPressed: _selectedRemote < _remotes.length - 1
              ? () => _updateSelectedRemote(_selectedRemote + 1)
              : null,
        ),
      ],
    );
  }
}

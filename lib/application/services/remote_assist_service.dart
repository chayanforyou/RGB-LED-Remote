import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RemoteAssistPromptService {
  static const _dialogShownPrefKey = "hasShownRemoteAssistDialog";
  static const _tapCountPrefKey = "remoteAssistTapCount";
  static const _tapThreshold = 3;

  /// Call this when a relevant UI interaction happens (e.g., button tap).
  /// It tracks the count and shows a prompt once a threshold is reached.
  static Future<void> maybeShowPrompt({required VoidCallback onPrompt}) async {
    final prefs = await SharedPreferences.getInstance();

    final currentTapCount = (prefs.getInt(_tapCountPrefKey) ?? 0) + 1;
    final hasShown = prefs.getBool(_dialogShownPrefKey) ?? false;

    await prefs.setInt(_tapCountPrefKey, currentTapCount);

    if (currentTapCount >= _tapThreshold && !hasShown) {
      await prefs.setBool(_dialogShownPrefKey, true);
      onPrompt.call();
    }
  }
}


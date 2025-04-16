class AppSettings {
  final bool isVibrationEnabled;
  final bool isLightEnabled;
  final bool isSoundEnabled;
  final String? soundFileName;
  final int remoteIndex;

  const AppSettings({
    this.isVibrationEnabled = false,
    this.isLightEnabled = false,
    this.isSoundEnabled = false,
    this.soundFileName,
    this.remoteIndex = 0,
  });

  AppSettings copyWith({
    bool? isVibrationEnabled,
    bool? isLightEnabled,
    bool? isSoundEnabled,
    String? soundFileName,
    int? remoteIndex,
  }) {
    return AppSettings(
      isVibrationEnabled: isVibrationEnabled ?? this.isVibrationEnabled,
      isLightEnabled: isLightEnabled ?? this.isLightEnabled,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      soundFileName: soundFileName ?? this.soundFileName,
      remoteIndex: remoteIndex ?? this.remoteIndex,
    );
  }
}
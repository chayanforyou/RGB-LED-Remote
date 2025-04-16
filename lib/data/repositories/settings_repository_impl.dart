import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsDataSource dataSource;

  SettingsRepositoryImpl(this.dataSource);

  @override
  Future<AppSettings> getSettings() => dataSource.getSettings();

  @override
  Future<void> updateSettings(AppSettings settings) => dataSource.saveSettings(settings);
}

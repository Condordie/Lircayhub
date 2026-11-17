import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/repositories/hike_history_repository.dart';
import 'core/repositories/qa_repository.dart';
import 'core/repositories/settings_repository.dart';
import 'core/services/app_settings.dart';
import 'core/services/haptic_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/offline_map_service.dart';
import 'core/services/share_service.dart';
import 'core/services/voice_service.dart';
import 'ui/screens/main_shell.dart';
import 'ui/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Abre el caché local de mapas; si falla, la app usa el mapa esquemático.
  final mapService = OfflineMapService();
  await mapService.initialize();

  final prefs = await SharedPreferences.getInstance();
  final haptic = HapticService();
  final voice = VoiceService();
  final notifications = NotificationService();
  final settings = AppSettings(
    haptic: haptic,
    voice: voice,
    notifications: notifications,
    repository: SharedPrefsSettingsRepository(prefs),
  );
  await settings.load();

  runApp(
    LircayHubApp(
      mapService: mapService,
      haptic: haptic,
      voice: voice,
      notifications: notifications,
      settings: settings,
      history: SharedPrefsHikeHistoryRepository(prefs),
      qa: AssetQaRepository(prefs),
    ),
  );
}

class LircayHubApp extends StatelessWidget {
  const LircayHubApp({
    super.key,
    required this.mapService,
    required this.haptic,
    required this.voice,
    required this.notifications,
    required this.settings,
    required this.history,
    required this.qa,
  });

  final OfflineMapService mapService;
  final HapticService haptic;
  final VoiceService voice;
  final NotificationService notifications;
  final AppSettings settings;
  final HikeHistoryRepository history;
  final QaRepository qa;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<OfflineMapService>.value(value: mapService),
        Provider<HapticService>.value(value: haptic),
        Provider<VoiceService>.value(value: voice),
        Provider<HikeHistoryRepository>.value(value: history),
        Provider<QaRepository>.value(value: qa),
        Provider<ShareService>(create: (_) => ShareService()),
        ChangeNotifierProvider<NotificationService>.value(value: notifications),
        ChangeNotifierProvider<AppSettings>.value(value: settings),
      ],
      child: MaterialApp(
        title: 'Lircay Trail',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const MainShell(),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/app_settings.dart';
import 'core/services/haptic_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/offline_map_service.dart';
import 'core/services/voice_service.dart';
import 'ui/screens/main_shell.dart';
import 'ui/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Abre el caché local de mapas; si falla, la app usa el mapa esquemático.
  final mapService = OfflineMapService();
  await mapService.initialize();
  runApp(LircayHubApp(mapService: mapService));
}

class LircayHubApp extends StatelessWidget {
  const LircayHubApp({super.key, required this.mapService});

  final OfflineMapService mapService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<OfflineMapService>.value(value: mapService),
        Provider<HapticService>(create: (_) => HapticService()),
        Provider<VoiceService>(
          create: (_) => VoiceService(),
          dispose: (_, service) => service.dispose(),
        ),
        ChangeNotifierProvider<NotificationService>(
          create: (_) => NotificationService(),
        ),
        ChangeNotifierProvider<AppSettings>(
          create: (ctx) => AppSettings(
            haptic: ctx.read<HapticService>(),
            voice: ctx.read<VoiceService>(),
            notifications: ctx.read<NotificationService>(),
          ),
        ),
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
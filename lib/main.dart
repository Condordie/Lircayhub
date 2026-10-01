import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/services/app_settings.dart';
import 'core/services/haptic_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/voice_service.dart';
import 'ui/screens/main_shell.dart';
import 'ui/theme/app_theme.dart';

void main() {
  runApp(const LircayHubApp());
}

class LircayHubApp extends StatelessWidget {
  const LircayHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
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

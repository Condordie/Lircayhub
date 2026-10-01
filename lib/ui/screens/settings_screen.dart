import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/app_settings.dart';
import '../theme/app_text_styles.dart';
import '../widgets/section_header.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppSettings>();

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionHeader(title: 'Guía durante la caminata'),
          Card(
            color: Colors.white,
            child: Column(
              children: [
                SwitchListTile(
                  value: s.hapticEnabled,
                  onChanged: s.setHapticEnabled,
                  secondary: const Icon(Icons.vibration),
                  title: const Text('Vibración'),
                  subtitle: const Text('Indicaciones que se sienten sin mirar'),
                ),
                SwitchListTile(
                  value: s.voiceEnabled,
                  onChanged: s.setVoiceEnabled,
                  secondary: const Icon(Icons.record_voice_over),
                  title: const Text('Voz'),
                  subtitle: const Text('Guía hablada y comandos de voz'),
                ),
                SwitchListTile(
                  value: s.notificationsEnabled,
                  onChanged: s.setNotificationsEnabled,
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text('Notificaciones'),
                  subtitle: const Text('Clima, cierres y hora límite'),
                ),
              ],
            ),
          ),
          const SectionHeader(title: 'Sobre este prototipo'),
          const Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Prototipo sin conexión ni base de datos. Se asume el mejor escenario: mapas siempre disponibles, GPS exacto, avisos entregados y SOS que siempre se envía. Los botones reproducen el comportamiento esperado de la app real.',
                style: AppTextStyles.body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/app_settings.dart';
import '../theme/app_text_styles.dart';
import '../widgets/section_header.dart';
import '../screens/qa_screen.dart';

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
          const SectionHeader(title: 'Beta testing'),
          Card(
            color: Colors.white,
            child: ListTile(
              leading: const Icon(Icons.rate_review_outlined),
              title: const Text('Evaluar el prototipo'),
              subtitle: const Text('Responde 6 preguntas y envía tu opinión'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const QaScreen()),
              ),
            ),
          ),
          const SectionHeader(title: 'Sobre este prototipo'),
          const Card(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Tus ajustes, contactos y caminatas se guardan en el teléfono y se mantienen al cerrar la app. El recorrido, el GPS y el envío del SOS aún se simulan.',
                style: AppTextStyles.body,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

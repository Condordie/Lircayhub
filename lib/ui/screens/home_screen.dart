import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/data/mock_data.dart';
import '../../core/enums/haptic_pattern.dart';
import '../../core/services/haptic_service.dart';
import '../../core/services/notification_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/alert_tile.dart';
import '../widgets/section_header.dart';
import '../widgets/trail_card.dart';
import 'trail_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _simulateAlert(BuildContext context) {
    context.read<NotificationService>().simulateWeatherAlert();
    context.read<HapticService>().play(HapticPattern.alert);
  }

  @override
  Widget build(BuildContext context) {
    final alerts = context.watch<NotificationService>().alerts;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lircay Trail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            tooltip: 'Simular aviso de clima',
            onPressed: () => _simulateAlert(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Explora Altos de Lircay', style: AppTextStyles.headline),
          const SizedBox(height: 6),
          const Text(
            'Rutas guiadas por vibración y voz, aunque no tengas señal.',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 14),
          const _OfflineBadge(),
          if (alerts.isNotEmpty) ...[
            const SectionHeader(title: 'Avisos activos'),
            for (final alert in alerts)
              AlertTile(
                alert: alert,
                onDismiss: () =>
                    context.read<NotificationService>().dismiss(alert.id),
              ),
          ],
          const SectionHeader(title: 'Senderos'),
          for (final trail in MockData.trails)
            TrailCard(
              trail: trail,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TrailDetailScreen(trail: trail),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OfflineBadge extends StatelessWidget {
  const _OfflineBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.moss.withAlpha(60),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        children: [
          Icon(Icons.offline_pin, color: AppColors.forestDark, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Mapas descargados · funciona sin señal',
              style: TextStyle(
                color: AppColors.forestDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/utils/formatters.dart';
import '../../models/trail.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/stat_tile.dart';
import '../widgets/trail_map_preview.dart';

class HikeSummaryScreen extends StatelessWidget {
  const HikeSummaryScreen({
    super.key,
    required this.trail,
    required this.elapsed,
    required this.distanceKm,
    required this.completed,
    required this.sosSent,
  });

  final Trail trail;
  final Duration elapsed;
  final double distanceKm;
  final bool completed;
  final bool sosSent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resumen'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Icon(
            completed ? Icons.emoji_events : Icons.flag_outlined,
            size: 64,
            color: completed ? AppColors.sunset : AppColors.forest,
          ),
          const SizedBox(height: 8),
          Text(
            completed ? '¡Caminata completada!' : 'Caminata finalizada',
            style: AppTextStyles.headline,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            trail.name,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TrailMapPreview(
            waypoints: trail.waypoints,
            currentIndex: completed ? trail.waypoints.length - 1 : null,
            height: 180,
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatTile(
                    icon: Icons.directions_walk,
                    value: '${formatKm(distanceKm)} km',
                    label: 'Recorrido',
                  ),
                  StatTile(
                    icon: Icons.timer_outlined,
                    value: formatElapsed(elapsed),
                    label: 'Tiempo (demo)',
                  ),
                  StatTile(
                    icon: Icons.trending_up,
                    value: '${trail.elevationGainM} m',
                    label: 'Desnivel',
                  ),
                ],
              ),
            ),
          ),
          if (sosSent)
            Card(
              color: Colors.white,
              child: const ListTile(
                leading: Icon(Icons.shield, color: AppColors.danger),
                title: Text('Se envió una alerta de emergencia'),
                subtitle: Text(
                  'Tus contactos recibieron tu ubicación durante esta caminata.',
                ),
              ),
            ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            icon: const Icon(Icons.home_outlined),
            label: const Text('Volver al inicio'),
          ),
        ],
      ),
    );
  }
}

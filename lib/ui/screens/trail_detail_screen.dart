import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/enums/nav_cue.dart';
import '../../core/services/haptic_service.dart';
import '../../core/services/voice_service.dart';
import '../../models/trail.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/enum_visuals.dart';
import '../widgets/difficulty_chip.dart';
import '../widgets/section_header.dart';
import '../widgets/stat_tile.dart';
import '../widgets/trail_map_preview.dart';
import 'active_hike_screen.dart';

class TrailDetailScreen extends StatelessWidget {
  const TrailDetailScreen({super.key, required this.trail});

  final Trail trail;

  void _testCue(BuildContext context, NavCue cue) {
    context.read<HapticService>().play(cue.haptic);
    context.read<VoiceService>().speak(cue.spokenText);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(cue.label),
          duration: const Duration(seconds: 2),
        ),
      );
  }

  void _startHike(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ActiveHikeScreen(trail: trail)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(trail.name)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: ElevatedButton.icon(
            onPressed: () => _startHike(context),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Iniciar caminata'),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TrailMapPreview(waypoints: trail.waypoints, height: 200),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Text(trail.name, style: AppTextStyles.headline)),
              DifficultyChip(difficulty: trail.difficulty),
            ],
          ),
          const SizedBox(height: 4),
          Text(trail.zone, style: AppTextStyles.caption),
          const SizedBox(height: 16),
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  StatTile(
                    icon: Icons.straighten,
                    value: '${trail.distanceKm} km',
                    label: 'Distancia',
                  ),
                  StatTile(
                    icon: Icons.trending_up,
                    value: '${trail.elevationGainM} m',
                    label: 'Desnivel',
                  ),
                  StatTile(
                    icon: Icons.schedule,
                    value: trail.durationLabel,
                    label: 'Duración',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(trail.description, style: AppTextStyles.body),
          if (trail.highlights.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final h in trail.highlights) Chip(label: Text(h)),
              ],
            ),
          ],
          const SectionHeader(title: 'Puntos del recorrido'),
          for (final wp in trail.waypoints)
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.moss.withAlpha(70),
                child: Icon(
                  wp.cue.icon,
                  size: 18,
                  color: AppColors.forestDark,
                ),
              ),
              title: Text(wp.name),
              subtitle: Text(wp.cue.label),
              trailing: Text(
                '${wp.distanceFromStartKm.toStringAsFixed(1)} km',
                style: AppTextStyles.caption,
              ),
            ),
          const SectionHeader(title: 'Prueba las indicaciones'),
          const Text(
            'Cada aviso combina un patrón de vibración distinto con una frase hablada, para guiarte sin mirar la pantalla.',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final cue in NavCue.values)
                OutlinedButton.icon(
                  onPressed: () => _testCue(context, cue),
                  icon: Icon(cue.icon, size: 18),
                  label: Text(cue.label),
                ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

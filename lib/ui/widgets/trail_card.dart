import 'package:flutter/material.dart';

import '../../models/trail.dart';
import '../theme/app_text_styles.dart';
import 'difficulty_chip.dart';
import 'stat_tile.dart';
import 'trail_map_preview.dart';

class TrailCard extends StatelessWidget {
  const TrailCard({super.key, required this.trail, required this.onTap});

  final Trail trail;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TrailMapPreview(
              waypoints: trail.waypoints,
              height: 120,
              borderRadius: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(trail.name, style: AppTextStyles.title),
                      ),
                      DifficultyChip(difficulty: trail.difficulty),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(trail.zone, style: AppTextStyles.caption),
                  const SizedBox(height: 14),
                  Row(
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

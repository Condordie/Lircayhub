import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/utils/formatters.dart';
import '../../models/trail.dart';
import '../theme/app_text_styles.dart';
import 'difficulty_chip.dart';
import 'stat_tile.dart';
import 'trail_image.dart';

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
            Stack(
              children: [
                Hero(
                  tag: 'trail-image-${trail.id}',
                  child: TrailImage(
                    asset: trail.imageAsset,
                    height: 160,
                    semanticLabel: trail.name,
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: DifficultyChip(difficulty: trail.difficulty),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(trail.name, style: AppTextStyles.title),
                  const SizedBox(height: 2),
                  Text(trail.zone, style: AppTextStyles.caption),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StatTile(
                        svgAsset: AppAssets.icDistancia,
                        value: '${formatKm(trail.distanceKm)} km',
                        label: 'Distancia',
                      ),
                      StatTile(
                        svgAsset: AppAssets.icDesnivel,
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

import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'trail_image.dart';

/// Cabecera del Home: foto de portada con el título encima.
class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final onImage = Theme.of(context).colorScheme.onPrimary;

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          const TrailImage(
            asset: AppAssets.imgPortada,
            height: 190,
            semanticLabel: 'Bosque nativo de Altos de Lircay',
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.forestDark.withAlpha(210),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 14,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Explora Altos de Lircay',
                  style: AppTextStyles.headline.copyWith(color: onImage),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rutas guiadas por vibración y voz, aunque no tengas señal.',
                  style: AppTextStyles.caption.copyWith(color: onImage),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

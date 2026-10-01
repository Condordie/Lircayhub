import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../theme/app_colors.dart';
import 'app_icon.dart';

/// Foto de assets/images. Si el archivo no se encuentra muestra un marcador
/// en lugar de romper la pantalla.
class TrailImage extends StatelessWidget {
  const TrailImage({
    super.key,
    required this.asset,
    this.height,
    this.semanticLabel,
  });

  final String asset;
  final double? height;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
      cacheWidth: 900,
      semanticLabel: semanticLabel,
      errorBuilder: (context, error, stackTrace) => Container(
        height: height,
        width: double.infinity,
        color: AppColors.moss.withAlpha(90),
        alignment: Alignment.center,
        child: const AppIcon(
          AppAssets.icDificultadFacil,
          size: 44,
          color: AppColors.forestDark,
        ),
      ),
    );
  }
}

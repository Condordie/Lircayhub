import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import 'app_icon.dart';

class VoiceButton extends StatelessWidget {
  const VoiceButton({
    super.key,
    required this.isListening,
    required this.onPressed,
  });

  final bool isListening;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: isListening ? AppColors.river : AppColors.forest,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: const SizedBox(
              width: 76,
              height: 76,
              child: Center(
                child: AppIcon(AppAssets.icVoz, size: 34, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          isListening ? 'Escuchando...' : 'Hablar',
          style: AppTextStyles.caption,
        ),
      ],
    );
  }
}

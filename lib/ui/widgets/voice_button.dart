import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

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
            child: SizedBox(
              width: 76,
              height: 76,
              child: Icon(
                isListening ? Icons.hearing : Icons.mic,
                color: Colors.white,
                size: 34,
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

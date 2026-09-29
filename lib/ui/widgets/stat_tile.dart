import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.forest, size: 22),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

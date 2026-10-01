import 'package:flutter/material.dart';

import '../../models/trail_alert.dart';
import '../theme/app_text_styles.dart';
import '../theme/enum_visuals.dart';
import 'app_icon.dart';

class AlertTile extends StatelessWidget {
  const AlertTile({super.key, required this.alert, this.onDismiss});

  final TrailAlert alert;
  final VoidCallback? onDismiss;

  String get _hhmm =>
      '${alert.time.hour.toString().padLeft(2, '0')}:${alert.time.minute.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final color = alert.type.color;
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        isThreeLine: true,
        leading: CircleAvatar(
          backgroundColor: color.withAlpha(35),
          child: AppIcon(alert.type.iconAsset, size: 22, color: color),
        ),
        title: Text(alert.title, style: AppTextStyles.semiBold),
        subtitle: Text('${alert.message}\n${alert.type.label} · $_hhmm'),
        trailing: onDismiss == null
            ? null
            : IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Descartar',
                onPressed: onDismiss,
              ),
      ),
    );
  }
}

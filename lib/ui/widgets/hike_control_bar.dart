import 'package:flutter/material.dart';

import '../../core/enums/hike_status.dart';

class HikeControlBar extends StatelessWidget {
  const HikeControlBar({
    super.key,
    required this.status,
    required this.onPauseResume,
    required this.onFinish,
    required this.onSummary,
  });

  final HikeStatus status;
  final VoidCallback onPauseResume;
  final VoidCallback onFinish;
  final VoidCallback onSummary;

  @override
  Widget build(BuildContext context) {
    if (status == HikeStatus.finished) {
      return ElevatedButton.icon(
        onPressed: onSummary,
        icon: const Icon(Icons.emoji_events_outlined),
        label: const Text('Ver resumen'),
      );
    }

    final paused = status == HikeStatus.paused;
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onPauseResume,
            icon: Icon(paused ? Icons.play_arrow : Icons.pause),
            label: Text(paused ? 'Continuar' : 'Pausar'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onFinish,
            icon: const Icon(Icons.stop),
            label: const Text('Terminar'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

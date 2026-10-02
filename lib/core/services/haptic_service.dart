import 'package:flutter/foundation.dart';
import 'package:vibration/vibration.dart';

import '../enums/haptic_pattern.dart';

/// Vibración del teléfono. No requiere conexión.
class HapticService {
  bool enabled = true;

  Future<void> play(HapticPattern pattern) async {
    if (!enabled) return;
    try {
      final hasVibrator = await Vibration.hasVibrator();
      if (hasVibrator != true) return;
      await Vibration.vibrate(pattern: pattern.pattern);
    } catch (e) {
      debugPrint('HapticService: $e');
    }
  }

  Future<void> stop() async {
    try {
      await Vibration.cancel();
    } catch (e) {
      debugPrint('HapticService: $e');
    }
  }
}

String formatElapsed(Duration d) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
  final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return h > 0 ? '$h:$m:$s' : '$m:$s';
}

/// Kilómetros con coma decimal, como se habla en Chile.
String formatKm(double km) => km.toStringAsFixed(1).replaceAll('.', ',');

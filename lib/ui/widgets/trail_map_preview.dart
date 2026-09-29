import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/waypoint.dart';
import '../theme/app_colors.dart';

/// Mapa esquemático de la ruta (simulado, siempre disponible sin conexión).
/// [currentIndex] marca la posición actual; se usa en la caminata activa.
class TrailMapPreview extends StatelessWidget {
  const TrailMapPreview({
    super.key,
    required this.waypoints,
    this.currentIndex,
    this.height = 160,
    this.borderRadius = 16,
  });

  final List<Waypoint> waypoints;
  final int? currentIndex;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: CustomPaint(painter: _RoutePainter(waypoints, currentIndex)),
      ),
    );
  }
}

class _RoutePainter extends CustomPainter {
  _RoutePainter(this.waypoints, this.currentIndex);

  final List<Waypoint> waypoints;
  final int? currentIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    canvas.drawRect(
      rect,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFDDE8D5), Color(0xFFC5D9C0)],
        ).createShader(rect),
    );

    final grid = Paint()
      ..color = Colors.white.withAlpha(90)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 32) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), grid);
    }
    for (double y = 0; y < size.height; y += 32) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    if (waypoints.length < 2) return;

    final lats = waypoints.map((w) => w.latitude);
    final lngs = waypoints.map((w) => w.longitude);
    final minLat = lats.reduce(min);
    final maxLat = lats.reduce(max);
    final minLng = lngs.reduce(min);
    final maxLng = lngs.reduce(max);

    const pad = 28.0;
    final k = cos((minLat + maxLat) / 2 * pi / 180);
    final spanX = max((maxLng - minLng) * k, 1e-9);
    final spanY = max(maxLat - minLat, 1e-9);
    final scale = min(
      (size.width - 2 * pad) / spanX,
      (size.height - 2 * pad) / spanY,
    );
    final offX = (size.width - spanX * scale) / 2;
    final offY = (size.height - spanY * scale) / 2;

    Offset project(Waypoint w) => Offset(
          offX + (w.longitude - minLng) * k * scale,
          size.height - offY - (w.latitude - minLat) * scale,
        );

    final points = waypoints.map(project).toList();
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.forest
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    final border = Paint()..color = Colors.white;
    for (var i = 0; i < points.length; i++) {
      final isStart = i == 0;
      final isEnd = i == points.length - 1;
      final radius = (isStart || isEnd) ? 8.0 : 5.0;
      final fill = isStart
          ? AppColors.moss
          : isEnd
              ? AppColors.sunset
              : AppColors.forestDark;
      canvas.drawCircle(points[i], radius + 2, border);
      canvas.drawCircle(points[i], radius, Paint()..color = fill);
    }

    final current = currentIndex;
    if (current != null && current >= 0 && current < points.length) {
      canvas.drawCircle(
        points[current],
        16,
        Paint()..color = AppColors.river.withAlpha(70),
      );
      canvas.drawCircle(points[current], 7, Paint()..color = AppColors.river);
      canvas.drawCircle(
        points[current],
        7,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RoutePainter old) =>
      old.waypoints != waypoints || old.currentIndex != currentIndex;
}

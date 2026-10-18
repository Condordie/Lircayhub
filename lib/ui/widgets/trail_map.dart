import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../core/services/offline_map_service.dart';
import '../../models/waypoint.dart';
import '../theme/app_colors.dart';
import 'trail_map_preview.dart';

/// Mapa real (teselas en caché, funciona sin conexión si se descargó la
/// región). Misma firma que [TrailMapPreview]; si el caché no está
/// disponible, cae a ese mapa esquemático.
class TrailMap extends StatelessWidget {
  const TrailMap({
    super.key,
    required this.waypoints,
    this.currentIndex,
    this.legFraction,
    this.height = 160,
    this.borderRadius = 16,
    this.interactive = false,
  });

  final List<Waypoint> waypoints;
  final int? currentIndex;
  final double? legFraction;
  final double height;
  final double borderRadius;

  /// false: el mapa no captura gestos (no pelea con el scroll de la lista).
  final bool interactive;

  LatLng? _currentPosition(List<LatLng> pts) {
    final i = currentIndex;
    if (i == null || i < 0 || i >= pts.length) return null;
    var pos = pts[i];
    final f = legFraction;
    if (f != null && i < pts.length - 1) {
      final t = f.clamp(0.0, 1.0).toDouble();
      pos = LatLng(
        pos.latitude + (pts[i + 1].latitude - pos.latitude) * t,
        pos.longitude + (pts[i + 1].longitude - pos.longitude) * t,
      );
    }
    return pos;
  }

  Marker _dot(LatLng p, Color color, double size) => Marker(
        point: p,
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final service = context.read<OfflineMapService>();
    if (!service.available || waypoints.length < 2) {
      return TrailMapPreview(
        waypoints: waypoints,
        currentIndex: currentIndex,
        legFraction: legFraction,
        height: height,
        borderRadius: borderRadius,
      );
    }

    final pts = waypoints.map((w) => LatLng(w.latitude, w.longitude)).toList();
    final pos = _currentPosition(pts);
    final i = currentIndex;
    final covered = <LatLng>[
      if (i != null && pos != null) ...pts.take(i + 1),
      if (pos != null) pos,
    ];

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: FlutterMap(
          options: MapOptions(
            initialCameraFit: CameraFit.bounds(
              bounds: LatLngBounds.fromPoints(pts),
              padding: const EdgeInsets.all(32),
              maxZoom: OfflineMapService.maxZoom.toDouble(),
            ),
            minZoom: OfflineMapService.minZoom.toDouble(),
            maxZoom: 17,
            interactionOptions: InteractionOptions(
              flags: interactive
                  ? InteractiveFlag.all & ~InteractiveFlag.rotate
                  : InteractiveFlag.none,
            ),
          ),
          children: [
            service.tileLayer(),
            PolylineLayer(polylines: [
              Polyline(
                points: pts,
                strokeWidth: 4,
                color: pos == null ? AppColors.forest : AppColors.moss,
                borderStrokeWidth: 2,
                borderColor: Colors.white,
              ),
              if (covered.length >= 2)
                Polyline(
                  points: covered,
                  strokeWidth: 4,
                  color: AppColors.forest,
                ),
            ]),
            MarkerLayer(markers: [
              _dot(pts.first, AppColors.moss, 18),
              _dot(pts.last, AppColors.sunset, 18),
              if (pos != null) _dot(pos, AppColors.river, 20),
            ]),
            const SimpleAttributionWidget(
              source: Text('© OpenStreetMap'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../core/data/mock_data.dart';
import 'package:lircayhub/core/services/offline_map_service.dart';

/// Entry point SOLO de la PoC (no modifica lib/main.dart):
///   flutter run -t lib/poc/poc_offline_map_main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = OfflineMapService();
  String? initError;
  try {
    await service.initialize();
  } catch (e) {
    initError = e.toString();
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PocOfflineMapScreen(service: service, initError: initError),
  ));
}

class PocOfflineMapScreen extends StatefulWidget {
  const PocOfflineMapScreen({super.key, required this.service, this.initError});

  final OfflineMapService service;
  final String? initError;

  @override
  State<PocOfflineMapScreen> createState() => _PocOfflineMapScreenState();
}

class _PocOfflineMapScreenState extends State<PocOfflineMapScreen> {
  bool _offlineOnly = false;
  bool _busy = false;
  String _log = '';

  @override
  void initState() {
    super.initState();
    if (widget.initError != null) {
      _log = 'ERROR al inicializar caché: ${widget.initError}';
    } else {
      _refreshStats();
    }
  }

  Future<void> _refreshStats() async {
    try {
      final n = await widget.service.cachedTiles();
      final kib = await widget.service.cachedSizeKiB();
      setState(() => _log = 'Caché: $n tiles (${kib.toStringAsFixed(0)} KiB)');
    } catch (e) {
      setState(() => _log = 'ERROR leyendo estadísticas: $e');
    }
  }

  Future<void> _download() async {
    setState(() {
      _busy = true;
      _log = 'Calculando tiles...';
    });
    try {
      final total = await widget.service.countTiles();
      setState(() => _log = 'Descargando $total tiles...');
      await for (final pct in widget.service.downloadRegion()) {
        if (!mounted) return;
        setState(() => _log = 'Descargando: ${pct.toStringAsFixed(1)}%');
      }
      await _refreshStats();
    } catch (e) {
      // Sin red, disco lleno, etc.
      setState(() => _log = 'ERROR en la descarga: $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _clear() async {
    try {
      await widget.service.clear();
      await _refreshStats();
    } catch (e) {
      setState(() => _log = 'ERROR al borrar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Reutiliza el modelo existente solo para LEER la ruta (no se modifica).
    final route = MockData.trails.first.waypoints
        .map((w) => LatLng(w.latitude, w.longitude))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('PoC mapa offline')),
      body: Column(
        children: [
          Expanded(
            child: widget.initError != null
                ? const Center(child: Text('Caché no disponible'))
                : FlutterMap(
                    // key: fuerza recrear la capa al cambiar de modo.
                    key: ValueKey(_offlineOnly),
                    options: MapOptions(
                      initialCenter: OfflineMapService.center,
                      initialZoom: 14,
                      minZoom: OfflineMapService.minZoom.toDouble(),
                      maxZoom: OfflineMapService.maxZoom.toDouble(),
                    ),
                    children: [
                      widget.service.tileLayer(offlineOnly: _offlineOnly),
                      PolylineLayer(polylines: [
                        Polyline(
                          points: route,
                          strokeWidth: 4,
                          color: Colors.red,
                        ),
                      ]),
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_log),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Solo caché (simular sin conexión)'),
                  value: _offlineOnly,
                  onChanged: (v) => setState(() => _offlineOnly = v),
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _busy || widget.initError != null
                          ? null
                          : _download,
                      child: const Text('Descargar región'),
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton(
                      onPressed: _busy || widget.initError != null
                          ? null
                          : _clear,
                      child: const Text('Borrar caché'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
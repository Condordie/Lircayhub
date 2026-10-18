import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/offline_map_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Botón + estado para descargar el mapa de la reserva y usarlo sin señal.
class OfflineMapDownloadTile extends StatefulWidget {
  const OfflineMapDownloadTile({super.key});

  @override
  State<OfflineMapDownloadTile> createState() => _OfflineMapDownloadTileState();
}

class _OfflineMapDownloadTileState extends State<OfflineMapDownloadTile> {
  late final OfflineMapService _service = context.read<OfflineMapService>();
  String _status = '';
  double? _progress;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    if (!_service.available) {
      _status = 'Mapa sin conexión no disponible en este dispositivo.';
      return;
    }
    try {
      final n = await _service.cachedTiles();
      if (!mounted) return;
      setState(() => _status = n > 0
          ? 'Mapa disponible sin conexión ($n teselas guardadas).'
          : 'Descárgalo con señal antes de salir a caminar.');
    } catch (e) {
      if (mounted) setState(() => _status = 'No se pudo leer el caché: $e');
    }
  }

  Future<void> _download() async {
    setState(() {
      _busy = true;
      _progress = 0;
      _status = 'Descargando mapa...';
    });
    try {
      await for (final pct in _service.downloadRegion()) {
        if (!mounted) return;
        setState(() => _progress = pct / 100);
      }
      await _refresh();
    } catch (e) {
      if (mounted) {
        setState(() => _status = 'No se pudo descargar (¿sin conexión?): $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _progress = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_status, style: AppTextStyles.caption),
            if (_progress != null) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: _progress,
                color: AppColors.forest,
              ),
            ],
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _busy || !_service.available ? null : _download,
              icon: const Icon(Icons.download),
              label: const Text('Descargar mapa sin conexión'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';

/// PoC: encapsula TODA la lógica de mapa offline (persistencia + descarga).
/// La UI solo llama a este servicio; así, al integrar en `main`, se mueve
/// a lib/core/services/ sin tocar las pantallas.
class OfflineMapService {
  static const String storeName = 'lircay_offline';
  static const String urlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String userAgent = 'cl.lircayhub.lircaytrail';

  /// Centro: Reserva Nacional Altos de Lircay (mismas coords que MockData).
  static final LatLng center = LatLng(-35.6042, -71.0714);

  /// Región a descargar (~6 x 6 km alrededor del centro).
  static final LatLngBounds bounds = LatLngBounds(
    LatLng(-35.6342, -71.1014),
    LatLng(-35.5742, -71.0414),
  );

  static const int minZoom = 12;
  static const int maxZoom = 15;

  final FMTCStore store = const FMTCStore(storeName);

  /// Abre la base local (ObjectBox) y crea el store si no existe.
  Future<void> initialize() async {
    await FMTCObjectBoxBackend().initialise();
    if (!await store.manage.ready) {
      await store.manage.create();
    }
  }

  TileLayer tileLayer({required bool offlineOnly}) => TileLayer(
        urlTemplate: urlTemplate,
        userAgentPackageName: userAgent,
        tileProvider: FMTCTileProvider(
          stores: {storeName: BrowseStoreStrategy.readUpdateCreate},
          loadingStrategy: offlineOnly
              ? BrowseLoadingStrategy.cacheOnly
              : BrowseLoadingStrategy.cacheFirst,
        ),
      );

  DownloadableRegion _region() => RectangleRegion(bounds).toDownloadable(
        minZoom: minZoom,
        maxZoom: maxZoom,
        options: TileLayer(
          urlTemplate: urlTemplate,
          userAgentPackageName: userAgent,
        ),
      );

  Future<int> countTiles() => store.download.countTiles(_region());

  /// Descarga la región. Emite el porcentaje (0-100). Lanza excepción si
  /// la red falla; la UI la captura y la muestra.
  Stream<double> downloadRegion() async* {
    final (:tileEvents, :downloadProgress) = store.download.startForeground(
      region: _region(),
      skipExistingTiles: true,
    );
    tileEvents.listen((_) {}); // se consume para no acumular eventos
    await for (final p in downloadProgress) {
      yield p.percentageProgress;
    }
  }

  Future<int> cachedTiles() => store.stats.length;

  /// Tamaño en KiB.
  Future<double> cachedSizeKiB() => store.stats.size;

  Future<void> clear() => store.manage.reset();
}
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';

/// Mapa sin conexión: encapsula persistencia local (FMTC + ObjectBox) y la
/// descarga de la región de Altos de Lircay. La UI nunca toca FMTC directo.
class OfflineMapService {
  static const String storeName = 'lircay_offline';
  static const String urlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String userAgent = 'cl.lircayhub.lircaytrail';

  /// Centro: Reserva Nacional Altos de Lircay (mismas coords que MockData).
  static final LatLng center = LatLng(-35.6042, -71.0714);

  /// Región a descargar; cubre todos los waypoints de MockData.
  static final LatLngBounds bounds = LatLngBounds(
    LatLng(-35.6342, -71.1014),
    LatLng(-35.5742, -71.0114),
  );

  static const int minZoom = 12;
  static const int maxZoom = 15;

  final FMTCStore store = const FMTCStore(storeName);

  /// false si la base local no pudo abrirse (la app cae al mapa esquemático).
  bool available = false;
  String? initError;

  /// Nunca lanza: registra el fallo en [initError] para degradar con gracia.
  Future<void> initialize() async {
    try {
      await FMTCObjectBoxBackend().initialise();
      if (!await store.manage.ready) {
        await store.manage.create();
      }
      available = true;
    } catch (e) {
      available = false;
      initError = e.toString();
    }
  }

  /// Capa de teselas con caché primero: usa disco y solo va a red si falta.
  /// Con [offlineOnly] = true NUNCA usa red (útil para demostrar el modo).
  TileLayer tileLayer({bool offlineOnly = false}) => TileLayer(
        urlTemplate: urlTemplate,
        userAgentPackageName: userAgent,
        maxNativeZoom: maxZoom, // más zoom = escala la tesela z15 guardada
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

  /// Descarga la región. Emite el porcentaje (0-100). Lanza si la red falla.
  Stream<double> downloadRegion() async* {
    final (:tileEvents, :downloadProgress) = store.download.startForeground(
      region: _region(),
      skipExistingTiles: true,
    );
    tileEvents.listen((_) {});
    await for (final p in downloadProgress) {
      yield p.percentageProgress;
    }
  }

  Future<int> cachedTiles() => store.stats.length;

  /// Tamaño en KiB.
  Future<double> cachedSizeKiB() => store.stats.size;

  Future<void> clear() => store.manage.reset();
}
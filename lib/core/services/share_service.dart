import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

/// abre el selector de compartir del teléfono
/// (correo, mensajería, etc.) con el contenido ya estructurado.
class ShareService {
  /// Devuelve false solo si el sistema no pudo abrir el selector.
  Future<bool> shareText({required String text, String? subject}) async {
    try {
      await SharePlus.instance.share(
        ShareParams(text: text, subject: subject),
      );
      return true;
    } catch (e) {
      debugPrint('ShareService: $e');
      return false;
    }
  }
}
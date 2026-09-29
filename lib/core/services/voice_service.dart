import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Guía hablada (texto a voz). En la fase 3 se suma el reconocimiento de comandos.
class VoiceService {
  final FlutterTts _tts = FlutterTts();
  bool _ready = false;
  bool enabled = true;

  Future<void> _init() async {
    if (_ready) return;
    try {
      final chile = await _tts.isLanguageAvailable('es-CL');
      await _tts.setLanguage(chile == true ? 'es-CL' : 'es-ES');
      await _tts.setSpeechRate(0.5);
      _ready = true;
    } catch (e) {
      debugPrint('VoiceService init: $e');
    }
  }

  Future<void> speak(String text) async {
    if (!enabled) return;
    try {
      await _init();
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      debugPrint('VoiceService: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (e) {
      debugPrint('VoiceService: $e');
    }
  }

  void dispose() {
    _tts.stop();
  }
}

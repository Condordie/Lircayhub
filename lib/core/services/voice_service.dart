import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Guía hablada (texto a voz) y comandos de voz (voz a texto).
class VoiceService {
  final FlutterTts _tts = FlutterTts();
  final SpeechToText _stt = SpeechToText();
  bool _ttsReady = false;
  bool _sttReady = false;
  bool enabled = true;

  Future<void> _initTts() async {
    if (_ttsReady) return;
    try {
      final chile = await _tts.isLanguageAvailable('es-CL');
      await _tts.setLanguage(chile == true ? 'es-CL' : 'es-ES');
      await _tts.setSpeechRate(0.5);
      _ttsReady = true;
    } catch (e) {
      debugPrint('VoiceService TTS init: $e');
    }
  }

  Future<void> speak(String text) async {
    if (!enabled) return;
    try {
      await _initTts();
      await _tts.stop();
      await _tts.speak(text);
    } catch (e) {
      debugPrint('VoiceService speak: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (e) {
      debugPrint('VoiceService stop: $e');
    }
  }

  /// Empieza a escuchar un comando. Devuelve false si no se pudo activar el micrófono.
  Future<bool> startListening(
    void Function(String text, bool isFinal) onResult,
  ) async {
    if (!enabled) return false;
    try {
      if (!_sttReady) {
        _sttReady = await _stt.initialize(
          onError: (e) => debugPrint('VoiceService STT: ${e.errorMsg}'),
        );
      }
      if (!_sttReady) return false;
      await _tts.stop();

      String? localeId;
      final locales = await _stt.locales();
      for (final l in locales) {
        final id = l.localeId.toLowerCase();
        if (id.startsWith('es_cl') || id.startsWith('es-cl')) {
          localeId = l.localeId;
          break;
        }
      }
      if (localeId == null) {
        for (final l in locales) {
          if (l.localeId.toLowerCase().startsWith('es')) {
            localeId = l.localeId;
            break;
          }
        }
      }

      await _stt.listen(
        onResult: (SpeechRecognitionResult r) =>
            onResult(r.recognizedWords, r.finalResult),
        listenOptions: SpeechListenOptions(localeId: localeId),
      );
      return true;
    } catch (e) {
      debugPrint('VoiceService listen: $e');
      return false;
    }
  }

  Future<void> stopListening() async {
    try {
      await _stt.stop();
    } catch (e) {
      debugPrint('VoiceService stopListening: $e');
    }
  }

  void dispose() {
    _tts.stop();
    _stt.cancel();
  }
}

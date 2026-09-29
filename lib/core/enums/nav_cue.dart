import 'haptic_pattern.dart';

/// Indicación de navegación: texto en pantalla, frase hablada y vibración.
enum NavCue {
  straight(
    'Sigue recto',
    'Continúa recto por el sendero',
    HapticPattern.straight,
  ),
  turnLeft(
    'Gira a la izquierda',
    'Gira a la izquierda en la bifurcación',
    HapticPattern.turnLeft,
  ),
  turnRight(
    'Gira a la derecha',
    'Gira a la derecha en la bifurcación',
    HapticPattern.turnRight,
  ),
  offTrail(
    'Te saliste del sendero',
    'Atención, te has desviado del sendero. Regresa por donde viniste',
    HapticPattern.offTrail,
  ),
  arrived(
    'Llegaste',
    'Has llegado a tu destino',
    HapticPattern.arrived,
  );

  const NavCue(this.label, this.spokenText, this.haptic);
  final String label;
  final String spokenText;
  final HapticPattern haptic;
}

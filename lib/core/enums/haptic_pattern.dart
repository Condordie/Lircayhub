/// Patrones de vibración en milisegundos: [espera, vibra, espera, vibra, ...]
/// Cada patrón se distingue al tacto, para guiarse sin mirar la pantalla.
enum HapticPattern {
  straight([0, 80]),
  turnLeft([0, 150, 120, 150]),
  turnRight([0, 500]),
  offTrail([0, 300, 100, 300, 100, 300]),
  arrived([0, 100, 100, 100, 100, 600]),
  alert([0, 400, 200, 400]),
  sos([0, 800, 200, 800, 200, 800]);

  const HapticPattern(this.pattern);
  final List<int> pattern;
}

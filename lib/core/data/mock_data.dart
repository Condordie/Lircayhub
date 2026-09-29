import '../../models/emergency_contact.dart';
import '../../models/trail.dart';
import '../../models/trail_alert.dart';
import '../../models/waypoint.dart';
import '../enums/alert_type.dart';
import '../enums/nav_cue.dart';
import '../enums/trail_difficulty.dart';

/// Datos de ejemplo (ilustrativos). El prototipo no usa red ni base de datos:
/// se asume el mejor caso, con mapas siempre disponibles y avisos siempre entregados.
class MockData {
  MockData._();

  static const List<Trail> trails = [
    Trail(
      id: 'valle-del-venado',
      name: 'Valle del Venado',
      zone: 'Altos de Lircay',
      description:
          'Ruta de bosque nativo con cruce de río y un mirador al valle. Ideal para un día completo.',
      difficulty: TrailDifficulty.moderate,
      distanceKm: 7.0,
      elevationGainM: 450,
      durationMinutes: 180,
      highlights: ['Bosque nativo', 'Cruce de río', 'Mirador'],
      waypoints: [
        Waypoint(
          name: 'Entrada CONAF',
          latitude: -35.6010,
          longitude: -71.0420,
          distanceFromStartKm: 0.0,
        ),
        Waypoint(
          name: 'Puente sobre el río',
          latitude: -35.5985,
          longitude: -71.0385,
          distanceFromStartKm: 1.5,
          cue: NavCue.turnRight,
        ),
        Waypoint(
          name: 'Bifurcación del bosque',
          latitude: -35.5950,
          longitude: -71.0400,
          distanceFromStartKm: 3.2,
          cue: NavCue.turnLeft,
        ),
        Waypoint(
          name: 'Mirador del valle',
          latitude: -35.5905,
          longitude: -71.0350,
          distanceFromStartKm: 5.4,
        ),
        Waypoint(
          name: 'Valle del Venado',
          latitude: -35.5870,
          longitude: -71.0300,
          distanceFromStartKm: 7.0,
          cue: NavCue.arrived,
        ),
      ],
    ),
    Trail(
      id: 'laguna-del-alto',
      name: 'Laguna del Alto',
      zone: 'Altos de Lircay',
      description:
          'Ascenso sostenido hasta una laguna de altura. Requiere buena condición física y salida temprano.',
      difficulty: TrailDifficulty.hard,
      distanceKm: 12.0,
      elevationGainM: 900,
      durationMinutes: 360,
      highlights: ['Laguna de altura', 'Vistas panorámicas'],
      waypoints: [
        Waypoint(
          name: 'Entrada CONAF',
          latitude: -35.6010,
          longitude: -71.0420,
          distanceFromStartKm: 0.0,
        ),
        Waypoint(
          name: 'Inicio del ascenso',
          latitude: -35.5990,
          longitude: -71.0450,
          distanceFromStartKm: 2.5,
          cue: NavCue.turnLeft,
        ),
        Waypoint(
          name: 'Cruce de quebrada',
          latitude: -35.5940,
          longitude: -71.0480,
          distanceFromStartKm: 5.0,
          cue: NavCue.turnRight,
        ),
        Waypoint(
          name: 'Portezuelo',
          latitude: -35.5890,
          longitude: -71.0470,
          distanceFromStartKm: 8.5,
        ),
        Waypoint(
          name: 'Laguna del Alto',
          latitude: -35.5850,
          longitude: -71.0440,
          distanceFromStartKm: 12.0,
          cue: NavCue.arrived,
        ),
      ],
    ),
    Trail(
      id: 'ribera-del-lircay',
      name: 'Ribera del Lircay',
      zone: 'Altos de Lircay',
      description:
          'Circuito corto y plano junto al río, pensado para familias y para probar la app por primera vez.',
      difficulty: TrailDifficulty.easy,
      distanceKm: 2.5,
      elevationGainM: 60,
      durationMinutes: 60,
      highlights: ['Junto al río', 'Apto para familias'],
      waypoints: [
        Waypoint(
          name: 'Entrada CONAF',
          latitude: -35.6010,
          longitude: -71.0420,
          distanceFromStartKm: 0.0,
        ),
        Waypoint(
          name: 'Poza del río',
          latitude: -35.6000,
          longitude: -71.0405,
          distanceFromStartKm: 0.9,
          cue: NavCue.turnRight,
        ),
        Waypoint(
          name: 'Mirador bajo',
          latitude: -35.5995,
          longitude: -71.0390,
          distanceFromStartKm: 1.8,
          cue: NavCue.turnLeft,
        ),
        Waypoint(
          name: 'Regreso a la entrada',
          latitude: -35.6008,
          longitude: -71.0418,
          distanceFromStartKm: 2.5,
          cue: NavCue.arrived,
        ),
      ],
    ),
  ];

  static const List<EmergencyContact> emergencyContacts = [
    EmergencyContact(
      name: 'Camila Rojas',
      phone: '+56 9 1234 5678',
      relationship: 'Hermana',
    ),
    EmergencyContact(
      name: 'Pedro Soto',
      phone: '+56 9 8765 4321',
      relationship: 'Amigo',
    ),
  ];

  static final List<TrailAlert> alerts = [
    TrailAlert(
      id: 'a1',
      type: AlertType.weather,
      title: 'Viento fuerte en la tarde',
      message:
          'Se esperan ráfagas sobre los 40 km/h después de las 15:00 en zonas altas.',
      time: DateTime(2026, 9, 29, 9, 0),
    ),
    TrailAlert(
      id: 'a2',
      type: AlertType.trailClosure,
      title: 'Tramo con nieve en Laguna del Alto',
      message: 'Se recomienda llevar bastones y calzado impermeable.',
      time: DateTime(2026, 9, 29, 8, 30),
    ),
    TrailAlert(
      id: 'a3',
      type: AlertType.returnDeadline,
      title: 'Hora límite de regreso',
      message: 'Debes estar de vuelta antes de las 18:00 para llegar con luz.',
      time: DateTime(2026, 9, 29, 7, 45),
    ),
  ];
}

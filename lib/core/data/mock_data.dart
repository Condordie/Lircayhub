import '../../models/emergency_contact.dart';
import '../../models/trail.dart';
import '../../models/trail_alert.dart';
import '../../models/waypoint.dart';
import '../constants/app_assets.dart';
import '../enums/alert_type.dart';
import '../enums/nav_cue.dart';
import '../enums/trail_difficulty.dart';

/// Datos de la Reserva Nacional Altos de Lircay (Región del Maule).
///
/// Estado de verificación de cada sendero (ver comentarios):
///  - VERIFICADO: distancia, dificultad y desnivel/tiempo tomados de Andeshandbook.
///  - PROVISORIO: nombre y existencia confirmados, pero cifras por verificar.
///
/// Las coordenadas son esquemáticas: solo sirven para dibujar el trazado
/// ilustrativo y no corresponden a un track GPS real.
class MockData {
  MockData._();

  static const double _lat = -35.6042;
  static const double _lng = -71.0714;

  static const List<Trail> trails = [
    // PROVISORIO: cifras por verificar con CONAF.
    Trail(
      id: 'mirador-del-rio',
      name: 'Mirador del Río',
      zone: 'Reserva Nacional Altos de Lircay',
      description:
          'Sendero corto que lleva a un mirador sobre el río Lircay. Es una buena primera caminata para conocer la reserva.',
      difficulty: TrailDifficulty.easy,
      distanceKm: 1.5,
      elevationGainM: 40,
      durationMinutes: 40,
      imageAsset: AppAssets.imgMiradorDelRio,
      highlights: ['Vista al río Lircay', 'Sendero corto'],
      waypoints: [
        Waypoint(
          name: 'Centro de Información CONAF',
          latitude: _lat,
          longitude: _lng,
          distanceFromStartKm: 0.0,
        ),
        Waypoint(
          name: 'Bosque junto al río',
          latitude: _lat + 0.002,
          longitude: _lng + 0.004,
          distanceFromStartKm: 0.6,
          cue: NavCue.turnRight,
        ),
        Waypoint(
          name: 'Mirador del Río',
          latitude: _lat + 0.001,
          longitude: _lng + 0.009,
          distanceFromStartKm: 1.5,
          cue: NavCue.arrived,
        ),
      ],
    ),
    // PROVISORIO: cifras por verificar con CONAF.
    Trail(
      id: 'cerro-el-peine',
      name: 'Cerro El Peine',
      zone: 'Reserva Nacional Altos de Lircay',
      description:
          'Sendero por el bosque maulino con vistas al cerro Peine, una de las cumbres más altas del entorno de Vilches.',
      difficulty: TrailDifficulty.moderate,
      distanceKm: 3.0,
      elevationGainM: 150,
      durationMinutes: 90,
      imageAsset: AppAssets.imgCerroPeine,
      highlights: ['Bosque maulino', 'Vista al cerro Peine'],
      waypoints: [
        Waypoint(
          name: 'Centro de Información CONAF',
          latitude: _lat,
          longitude: _lng,
          distanceFromStartKm: 0.0,
        ),
        Waypoint(
          name: 'Bosque maulino',
          latitude: _lat + 0.003,
          longitude: _lng + 0.003,
          distanceFromStartKm: 1.0,
          cue: NavCue.turnLeft,
        ),
        Waypoint(
          name: 'Faldeo del cerro Peine',
          latitude: _lat + 0.007,
          longitude: _lng + 0.005,
          distanceFromStartKm: 2.1,
          cue: NavCue.turnRight,
        ),
        Waypoint(
          name: 'Mirador del Peine',
          latitude: _lat + 0.010,
          longitude: _lng + 0.009,
          distanceFromStartKm: 3.0,
          cue: NavCue.arrived,
        ),
      ],
    ),
    // VERIFICADO (Andeshandbook): 11,7 km, 686 m de desnivel, dificultad fácil,
    // 4 a 5 horas de ida.
    Trail(
      id: 'mirador-del-venado',
      name: 'Mirador del Venado',
      zone: 'Reserva Nacional Altos de Lircay',
      description:
          'Sendero ancho y bien marcado por el bosque maulino, de pendientes suaves, hacia uno de los mejores miradores del valle del río Claro. Tiempo de ida: 4 a 5 horas.',
      difficulty: TrailDifficulty.easy,
      distanceKm: 11.7,
      elevationGainM: 686,
      durationMinutes: 270,
      imageAsset: AppAssets.imgMiradorDelVenado,
      highlights: ['Bosque maulino', 'Mirador al valle', 'Colores de otoño'],
      waypoints: [
        Waypoint(
          name: 'Centro de Información CONAF',
          latitude: _lat,
          longitude: _lng,
          distanceFromStartKm: 0.0,
        ),
        Waypoint(
          name: 'Camping Antahuara',
          latitude: _lat + 0.002,
          longitude: _lng + 0.003,
          distanceFromStartKm: 1.5,
        ),
        Waypoint(
          name: 'Valle del río Lircay',
          latitude: _lat + 0.006,
          longitude: _lng + 0.010,
          distanceFromStartKm: 4.8,
          cue: NavCue.turnLeft,
        ),
        Waypoint(
          name: 'Faldeos del cerro Peine',
          latitude: _lat + 0.010,
          longitude: _lng + 0.020,
          distanceFromStartKm: 8.2,
          cue: NavCue.turnRight,
        ),
        Waypoint(
          name: 'Mirador del Venado',
          latitude: _lat + 0.008,
          longitude: _lng + 0.030,
          distanceFromStartKm: 11.7,
          cue: NavCue.arrived,
        ),
      ],
    ),
    // PROVISORIO: continúa desde el Mirador del Venado; cifras por verificar.
    Trail(
      id: 'valle-del-venado',
      name: 'Valle del Venado',
      zone: 'Reserva Nacional Altos de Lircay',
      description:
          'Descenso desde el mirador hasta el fondo del valle, un paraje más aislado de la reserva. Hay camping en el valle solo en verano.',
      difficulty: TrailDifficulty.moderate,
      distanceKm: 15.0,
      elevationGainM: 700,
      durationMinutes: 330,
      imageAsset: AppAssets.imgValleDelVenado,
      highlights: ['Valle aislado', 'Camping de verano'],
      waypoints: [
        Waypoint(
          name: 'Centro de Información CONAF',
          latitude: _lat,
          longitude: _lng,
          distanceFromStartKm: 0.0,
        ),
        Waypoint(
          name: 'Camping Antahuara',
          latitude: _lat + 0.002,
          longitude: _lng + 0.003,
          distanceFromStartKm: 1.5,
        ),
        Waypoint(
          name: 'Mirador del Venado',
          latitude: _lat + 0.008,
          longitude: _lng + 0.030,
          distanceFromStartKm: 11.7,
          cue: NavCue.turnLeft,
        ),
        Waypoint(
          name: 'Bajada al valle',
          latitude: _lat + 0.003,
          longitude: _lng + 0.034,
          distanceFromStartKm: 13.4,
          cue: NavCue.turnRight,
        ),
        Waypoint(
          name: 'Valle del Venado',
          latitude: _lat - 0.002,
          longitude: _lng + 0.038,
          distanceFromStartKm: 15.0,
          cue: NavCue.arrived,
        ),
      ],
    ),
    // VERIFICADO (Andeshandbook): 12,0 km y dificultad moderada. Desnivel y
    // tiempo PROVISORIOS (el último tramo sube unos 500 m en poco más de 3 km).
    Trail(
      id: 'enladrillado',
      name: 'El Enladrillado',
      zone: 'Reserva Nacional Altos de Lircay',
      description:
          'Gran meseta a unos 2.200 m cubierta de roca basáltica en forma de ladrillos, con vista al valle del río Claro y a los nevados del este. Se puede hacer en un día largo o en dos jornadas.',
      difficulty: TrailDifficulty.moderate,
      distanceKm: 12.0,
      elevationGainM: 800,
      durationMinutes: 210,
      imageAsset: AppAssets.imgEnladrillado,
      highlights: ['Meseta a 2.200 m', 'Roca basáltica', 'Vista a los nevados'],
      waypoints: [
        Waypoint(
          name: 'Centro de Información CONAF',
          latitude: _lat,
          longitude: _lng,
          distanceFromStartKm: 0.0,
        ),
        Waypoint(
          name: 'Camping Antahuara',
          latitude: _lat + 0.002,
          longitude: _lng + 0.003,
          distanceFromStartKm: 1.5,
        ),
        Waypoint(
          name: 'Bosque del valle',
          latitude: _lat + 0.006,
          longitude: _lng + 0.012,
          distanceFromStartKm: 6.0,
          cue: NavCue.turnLeft,
        ),
        Waypoint(
          name: 'Inicio del ascenso',
          latitude: _lat + 0.009,
          longitude: _lng + 0.018,
          distanceFromStartKm: 9.0,
          cue: NavCue.turnRight,
        ),
        Waypoint(
          name: 'El Enladrillado',
          latitude: _lat + 0.014,
          longitude: _lng + 0.022,
          distanceFromStartKm: 12.0,
          cue: NavCue.arrived,
        ),
      ],
    ),
    // PROVISORIO: nombre confirmado; cifras y dificultad por verificar.
    // En la laguna está prohibido acampar.
    Trail(
      id: 'laguna-el-alto',
      name: 'Laguna El Alto',
      zone: 'Reserva Nacional Altos de Lircay',
      description:
          'Clásico de la reserva: se sube por el Enladrillado hasta una laguna de altura. Está prohibido acampar en la laguna y en el Enladrillado.',
      difficulty: TrailDifficulty.hard,
      distanceKm: 16.0,
      elevationGainM: 900,
      durationMinutes: 360,
      imageAsset: AppAssets.imgLagunaElAlto,
      highlights: ['Laguna de altura', 'Vía Enladrillado'],
      waypoints: [
        Waypoint(
          name: 'Centro de Información CONAF',
          latitude: _lat,
          longitude: _lng,
          distanceFromStartKm: 0.0,
        ),
        Waypoint(
          name: 'Camping Antahuara',
          latitude: _lat + 0.002,
          longitude: _lng + 0.003,
          distanceFromStartKm: 1.5,
        ),
        Waypoint(
          name: 'El Enladrillado',
          latitude: _lat + 0.014,
          longitude: _lng + 0.022,
          distanceFromStartKm: 12.0,
          cue: NavCue.turnLeft,
        ),
        Waypoint(
          name: 'Desvío a la laguna',
          latitude: _lat + 0.016,
          longitude: _lng + 0.016,
          distanceFromStartKm: 13.5,
          cue: NavCue.turnRight,
        ),
        Waypoint(
          name: 'Laguna El Alto',
          latitude: _lat + 0.019,
          longitude: _lng + 0.010,
          distanceFromStartKm: 16.0,
          cue: NavCue.arrived,
        ),
      ],
    ),
  ];

  static const List<EmergencyContact> emergencyContacts = [
    EmergencyContact(
      name: 'Christian Cabrera',
      phone: '+56 9 1234 5678',
      relationship: 'Hermana',
    ),
    EmergencyContact(
      name: 'John Doe',
      phone: '+56 9 8765 4321',
      relationship: 'Amigo',
    ),
  ];

  static final List<TrailAlert> alerts = [
    TrailAlert(
      id: 'a1',
      type: AlertType.weather,
      title: 'Viento fuerte en zonas altas',
      message:
          'Se esperan ráfagas sobre los 40 km/h en el Enladrillado y la laguna El Alto durante la tarde.',
      time: DateTime(2026, 10, 1, 9, 0),
    ),
    TrailAlert(
      id: 'a2',
      type: AlertType.trailClosure,
      title: 'Camping Valle del Venado solo en verano',
      message:
          'Fuera de la temporada estival solo está habilitado el camping Antahuara.',
      time: DateTime(2026, 10, 1, 8, 30),
    ),
    TrailAlert(
      id: 'a3',
      type: AlertType.returnDeadline,
      title: 'Regresa antes del cierre del portón',
      message:
          'El portón de Vilches Alto se cierra con candado a las 17:30 y no se puede salir en vehículo después.',
      time: DateTime(2026, 10, 1, 7, 45),
    ),
  ];
}

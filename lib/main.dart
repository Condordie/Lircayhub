import 'package:flutter/material.dart';

import 'core/data/mock_data.dart';
import 'ui/theme/app_theme.dart';

void main() {
  runApp(const LircayHubApp());
}

class LircayHubApp extends StatelessWidget {
  const LircayHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lircay Trail',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _PlaceholderHome(),
    );
  }
}

/// Pantalla temporal para verificar que enums, modelos, datos y tema
/// compilan bien. Se reemplaza por el onboarding y el Home en la fase 2.
class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lircay Trail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final trail in MockData.trails)
            Card(
              child: ListTile(
                title: Text(trail.name),
                subtitle: Text(
                  '${trail.difficulty.label} · ${trail.distanceKm} km · ${trail.durationLabel}',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/app_settings.dart';
import '../../core/services/haptic_service.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/voice_service.dart';
import '../../core/utils/formatters.dart';
import '../../models/trail.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../viewmodels/active_hike_view_model.dart';
import '../widgets/alert_tile.dart';
import '../widgets/hike_control_bar.dart';
import '../widgets/nav_cue_banner.dart';
import '../widgets/sos_button.dart';
import '../widgets/stat_tile.dart';
import '../widgets/trail_map_preview.dart';
import '../widgets/voice_button.dart';
import 'hike_summary_screen.dart';

class ActiveHikeScreen extends StatelessWidget {
  const ActiveHikeScreen({super.key, required this.trail});

  final Trail trail;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => ActiveHikeViewModel(
        trail: trail,
        haptic: ctx.read<HapticService>(),
        voice: ctx.read<VoiceService>(),
        notifications: ctx.read<NotificationService>(),
        settings: ctx.read<AppSettings>(),
      ),
      child: const _ActiveHikeView(),
    );
  }
}

class _ActiveHikeView extends StatelessWidget {
  const _ActiveHikeView();

  static const _voiceExamples = [
    '¿Cuánto falta?',
    '¿Dónde estoy?',
    'Repite',
    'Pausa',
    'Continuar',
  ];

  void _onDemo(BuildContext context, ActiveHikeViewModel vm, String value) {
    switch (value) {
      case 'offtrail':
        vm.simulateOffTrail();
      case 'fall':
        if (!vm.simulateFall()) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  'La detección de caídas está desactivada en Seguridad',
                ),
              ),
            );
        }
      case 'weather':
        vm.simulateWeatherAlert();
      case 'deadline':
        vm.simulateReturnDeadline();
    }
  }

  void _openSummary(BuildContext context, ActiveHikeViewModel vm) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => HikeSummaryScreen(
          trail: vm.trail,
          elapsed: vm.elapsed,
          distanceKm: vm.distanceCoveredKm,
          completed: vm.completed,
          sosSent: vm.sosSent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ActiveHikeViewModel>();
    final next = vm.nextWaypoint;

    return Scaffold(
      appBar: AppBar(
        title: Text(vm.trail.name),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.science_outlined),
            tooltip: 'Demo',
            onSelected: (v) => _onDemo(context, vm, v),
            itemBuilder: (_) => const [
              PopupMenuItem<String>(
                value: 'offtrail',
                child: Text('Simular desvío del sendero'),
              ),
              PopupMenuItem<String>(
                value: 'fall',
                child: Text('Simular caída'),
              ),
              PopupMenuItem<String>(
                value: 'weather',
                child: Text('Simular aviso de clima'),
              ),
              PopupMenuItem<String>(
                value: 'deadline',
                child: Text('Simular hora límite'),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (vm.bannerAlert != null)
                      AlertTile(alert: vm.bannerAlert!),
                    NavCueBanner(
                      cue: vm.cue,
                      subtitle: next == null
                          ? 'Llegaste al final del recorrido'
                          : 'Próximo: ${next.name}',
                    ),
                    const SizedBox(height: 14),
                    TrailMapPreview(
                      waypoints: vm.trail.waypoints,
                      currentIndex: vm.currentIndex,
                      legFraction: vm.legFraction,
                      height: 210,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${vm.status.label} · recorrido simulado y acelerado',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 10),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                StatTile(
                                  icon: Icons.directions_walk,
                                  value: '${formatKm(vm.distanceCoveredKm)} km',
                                  label: 'Recorrido',
                                ),
                                StatTile(
                                  icon: Icons.flag_outlined,
                                  value: '${formatKm(vm.remainingKm)} km',
                                  label: 'Faltan',
                                ),
                                StatTile(
                                  icon: Icons.timer_outlined,
                                  value: formatElapsed(vm.elapsed),
                                  label: 'Tiempo',
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: vm.progress,
                                minHeight: 8,
                                color: AppColors.forest,
                                backgroundColor:
                                    AppColors.moss.withAlpha(70),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.record_voice_over,
                                  color: AppColors.forest,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    vm.isListening && vm.lastHeard != null
                                        ? 'Escuché: ${vm.lastHeard}'
                                        : vm.lastMessage ??
                                            'Di "cuánto falta", "pausa" o "auxilio"',
                                    style: AppTextStyles.body,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Comandos de voz (toca para simularlos)',
                              style: AppTextStyles.caption,
                            ),
                            const SizedBox(height: 6),
                            Wrap(
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                for (final c in _voiceExamples)
                                  ActionChip(
                                    label: Text(c),
                                    onPressed: () => vm.handleCommand(c),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SosButton(onConfirmed: vm.triggerSos),
                          VoiceButton(
                            isListening: vm.isListening,
                            onPressed: vm.toggleListening,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      HikeControlBar(
                        status: vm.status,
                        onPauseResume: vm.togglePause,
                        onFinish: () {
                          vm.finish();
                          _openSummary(context, vm);
                        },
                        onSummary: () => _openSummary(context, vm),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (vm.fallActive) _FallOverlay(vm: vm),
          if (vm.sosNoticeVisible) _SosSentOverlay(vm: vm),
        ],
      ),
    );
  }
}

class _FallOverlay extends StatelessWidget {
  const _FallOverlay({required this.vm});

  final ActiveHikeViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 56,
                  color: AppColors.danger,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Detectamos una posible caída',
                  style: AppTextStyles.title,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  '${vm.fallCountdown}',
                  style: AppTextStyles.extraBold.copyWith(
                    fontSize: 64,
                    color: AppColors.danger,
                  ),
                ),
                const Text(
                  'Si no respondes, se enviará una alerta a tus contactos con tu ubicación.',
                  style: AppTextStyles.caption,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: vm.confirmOk,
                  child: const Text('Estoy bien'),
                ),
                const SizedBox(height: 10),
                OutlinedButton(
                  onPressed: vm.sendAlertNow,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    foregroundColor: AppColors.danger,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Enviar alerta ahora'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SosSentOverlay extends StatelessWidget {
  const _SosSentOverlay({required this.vm});

  final ActiveHikeViewModel vm;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(24),
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Icon(
                    Icons.check_circle,
                    size: 56,
                    color: Color(0xFF3E8E5A),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(
                  child: Text('Alerta enviada', style: AppTextStyles.title),
                ),
                const SizedBox(height: 14),
                Text(
                  'Ubicación compartida: ${vm.currentWaypoint.name}',
                  style: AppTextStyles.body,
                ),
                const SizedBox(height: 8),
                const Text('Contactos notificados:', style: AppTextStyles.caption),
                for (final c in vm.contacts)
                  Text('• ${c.name} (${c.phone})', style: AppTextStyles.body),
                if (vm.contacts.isEmpty)
                  const Text(
                    'No hay contactos guardados todavía.',
                    style: AppTextStyles.body,
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: vm.dismissSosNotice,
                  child: const Text('Entendido'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

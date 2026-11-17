import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/repositories/hike_history_repository.dart';
import '../../core/utils/formatters.dart';
import '../../models/hike_record.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../viewmodels/history_view_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => HistoryViewModel(ctx.read<HikeHistoryRepository>()),
      child: const _HistoryView(),
    );
  }
}

class _HistoryView extends StatelessWidget {
  const _HistoryView();

  Future<void> _confirmClear(BuildContext context, HistoryViewModel vm) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Borrar historial'),
        content: const Text('Se eliminarán todas tus caminatas guardadas.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Borrar'),
          ),
        ],
      ),
    );
    if (ok == true) await vm.clear();
  }

  String _date(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} ${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistoryViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial'),
        actions: [
          if (!vm.isEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Borrar historial',
              onPressed: () => _confirmClear(context, vm),
            ),
        ],
      ),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : vm.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Aún no hay caminatas. Termina una y aparecerá aquí.',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      '${vm.records.length} caminatas · '
                      '${vm.completedCount} completas · '
                      '${formatKm(vm.totalKm)} km en total',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 12),
                    for (final r in vm.records) _RecordTile(r, _date(r.startedAt)),
                  ],
                ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile(this.record, this.date);

  final HikeRecord record;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(
          record.completed ? Icons.emoji_events : Icons.flag_outlined,
          color: record.completed ? AppColors.sunset : AppColors.forest,
        ),
        title: Text(record.trailName, style: AppTextStyles.semiBold),
        subtitle: Text(
          '$date · ${formatKm(record.distanceKm)} km · '
          '${formatElapsed(Duration(seconds: record.elapsedSeconds))}'
          '${record.sosSent ? ' · SOS enviado' : ''}',
        ),
      ),
    );
  }
}
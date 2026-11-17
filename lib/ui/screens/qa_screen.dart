import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/repositories/qa_repository.dart';
import '../../core/services/share_service.dart';
import '../../models/qa_instrument.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../viewmodels/qa_view_model.dart';
import '../widgets/section_header.dart';

class QaScreen extends StatelessWidget {
  const QaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => QaViewModel(
        repository: ctx.read<QaRepository>(),
        share: ctx.read<ShareService>(),
      ),
      child: const _QaView(),
    );
  }
}

class _QaView extends StatelessWidget {
  const _QaView();

  Future<void> _submit(BuildContext context, QaViewModel vm) async {
    final result = await vm.submit();
    if (!context.mounted) return;
    final text = switch (result) {
      QaSubmitResult.shared =>
        '¡Gracias! Tu evaluación quedó guardada y lista para enviar.',
      QaSubmitResult.savedOnly =>
        'Tu evaluación quedó guardada, pero no se pudo abrir el menú de compartir.',
      QaSubmitResult.invalid => 'Elige tu perfil y responde todas las preguntas.',
    };
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QaViewModel>();
    final instrument = vm.instrument;

    return Scaffold(
      appBar: AppBar(title: const Text('Evaluar el prototipo')),
      body: vm.loading
          ? const Center(child: CircularProgressIndicator())
          : instrument == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      vm.error ?? 'Instrumento no disponible.',
                      style: AppTextStyles.body,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text(
                      'Gracias por probar Lircay Trail. Responde las preguntas y, al final, se abrirá el menú de compartir para enviar tu evaluación por correo u otra aplicación.',
                      style: AppTextStyles.body,
                    ),
                    const SectionHeader(title: 'Tu perfil'),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final p in instrument.perfiles)
                          ChoiceChip(
                            label: Text(p.nombre),
                            selected: vm.profileId == p.id,
                            onSelected: (_) => vm.selectProfile(p.id),
                          ),
                      ],
                    ),
                    const SectionHeader(
                      title: 'Cumplimiento de historias de usuario',
                    ),
                    for (final q in instrument.cumplimientoHu)
                      _QuestionCard(question: q, vm: vm),
                    const SectionHeader(title: 'Usabilidad y experiencia'),
                    for (final q in instrument.usabilidad)
                      _QuestionCard(question: q, vm: vm),
                    const SectionHeader(title: 'Comentarios (opcional)'),
                    TextFormField(
                      key: ValueKey(vm.formVersion),
                      maxLines: 3,
                      onChanged: vm.setComment,
                      decoration: const InputDecoration(
                        hintText: '¿Qué funcionó y qué mejorarías?',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Respondidas ${vm.answeredCount} de ${vm.totalQuestions}'
                      '${vm.profileId == null ? ' · falta elegir tu perfil' : ''}',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      onPressed:
                          vm.canSubmit ? () => _submit(context, vm) : null,
                      icon: vm.submitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                      label: const Text('Enviar evaluación'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Evaluaciones guardadas en este teléfono: ${vm.submissionsCount}'
                      ' (${[
                        for (final p in instrument.perfiles)
                          '${p.id}: ${vm.countForProfile(p.id)}'
                      ].join(' · ')})',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard({required this.question, required this.vm});

  final QaQuestion question;
  final QaViewModel vm;

  @override
  Widget build(BuildContext context) {
    final value = vm.answerFor(question.id);
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question.titulo, style: AppTextStyles.semiBold),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 1; i <= 5; i++)
                  IconButton(
                    tooltip: '$i de 5',
                    onPressed: () => vm.setAnswer(question.id, i),
                    icon: Icon(
                      i <= value ? Icons.star : Icons.star_border,
                      color: AppColors.sunset,
                      size: 36,
                    ),
                  ),
              ],
            ),
            Text(question.min, style: AppTextStyles.caption),
            const SizedBox(height: 2),
            Text(question.max, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}
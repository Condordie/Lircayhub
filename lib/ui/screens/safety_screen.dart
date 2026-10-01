import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/services/app_settings.dart';
import '../../models/emergency_contact.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../widgets/section_header.dart';

class SafetyScreen extends StatelessWidget {
  const SafetyScreen({super.key});

  Future<void> _pickTime(BuildContext context, AppSettings s) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: s.deadlineHour, minute: s.deadlineMinute),
    );
    if (picked != null) s.setDeadline(picked.hour, picked.minute);
  }

  Future<void> _addContact(BuildContext context, AppSettings s) async {
    final contact = await showDialog<EmergencyContact>(
      context: context,
      builder: (_) => const _AddContactDialog(),
    );
    if (contact != null) s.addContact(contact);
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<AppSettings>();

    return Scaffold(
      appBar: AppBar(title: const Text('Seguridad')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Estas personas reciben tu ubicación si activas el SOS o si no respondes tras una caída.',
            style: AppTextStyles.caption,
          ),
          const SectionHeader(title: 'Contactos de emergencia'),
          if (s.contacts.isEmpty)
            const Text(
              'Aún no tienes contactos. Agrega al menos uno.',
              style: AppTextStyles.body,
            ),
          for (final c in s.contacts)
            Card(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.moss.withAlpha(90),
                  child: Text(
                    c.name.isEmpty ? '?' : c.name[0].toUpperCase(),
                    style: const TextStyle(color: AppColors.forestDark),
                  ),
                ),
                title: Text(c.name),
                subtitle: Text('${c.relationship} · ${c.phone}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Quitar',
                  onPressed: () => s.removeContact(c),
                ),
              ),
            ),
          OutlinedButton.icon(
            onPressed: () => _addContact(context, s),
            icon: const Icon(Icons.person_add_alt),
            label: const Text('Agregar contacto'),
          ),
          const SectionHeader(title: 'Hora límite de regreso'),
          Card(
            color: Colors.white,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.schedule, color: AppColors.forest),
                  title: Text(
                    s.deadlineLabel,
                    style: AppTextStyles.title,
                  ),
                  subtitle: const Text('Te avisamos antes de que se cumpla'),
                  trailing: TextButton(
                    onPressed: () => _pickTime(context, s),
                    child: const Text('Cambiar'),
                  ),
                ),
                SwitchListTile(
                  value: s.notifyIfLate,
                  onChanged: s.setNotifyIfLate,
                  title: const Text('Avisar a mis contactos si no vuelvo'),
                ),
              ],
            ),
          ),
          const SectionHeader(title: 'Detección de caídas'),
          Card(
            color: Colors.white,
            child: SwitchListTile(
              value: s.fallDetectionEnabled,
              onChanged: s.setFallDetectionEnabled,
              title: const Text('Detectar caídas con el acelerómetro'),
              subtitle: const Text(
                'Te pregunta si estás bien y, sin respuesta en 10 segundos, envía la alerta.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddContactDialog extends StatefulWidget {
  const _AddContactDialog();

  @override
  State<_AddContactDialog> createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<_AddContactDialog> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _relationship = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _relationship.dispose();
    super.dispose();
  }

  void _save() {
    final name = _name.text.trim();
    final phone = _phone.text.trim();
    if (name.isEmpty || phone.isEmpty) return;
    final rel = _relationship.text.trim();
    Navigator.of(context).pop(
      EmergencyContact(
        name: name,
        phone: phone,
        relationship: rel.isEmpty ? 'Contacto' : rel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nuevo contacto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Nombre'),
            textCapitalization: TextCapitalization.words,
          ),
          TextField(
            controller: _phone,
            decoration: const InputDecoration(labelText: 'Teléfono'),
            keyboardType: TextInputType.phone,
          ),
          TextField(
            controller: _relationship,
            decoration: const InputDecoration(labelText: 'Relación (opcional)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(onPressed: _save, child: const Text('Guardar')),
      ],
    );
  }
}

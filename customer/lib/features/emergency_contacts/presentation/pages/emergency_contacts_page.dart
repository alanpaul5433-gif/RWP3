import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../bloc/emergency_contacts_bloc.dart';

class EmergencyContactsPage extends StatelessWidget {
  const EmergencyContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocBuilder<EmergencyContactsBloc, EmergencyContactsState>(
        builder: (context, state) {
          if (state is EmergencyContactsLoading) return const Center(child: CircularProgressIndicator());
          final contacts = state is EmergencyContactsLoaded ? state.contacts : <EmergencyContactEntity>[];

          if (contacts.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.contact_phone_outlined, size: 48, color: colorScheme.outline),
              const SizedBox(height: 12),
              Text('No emergency contacts', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline)),
              const SizedBox(height: 8),
              Text('Tap + to add one', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.outline)),
            ]));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: colorScheme.primaryContainer,
                      child: Icon(Icons.person, color: colorScheme.onPrimaryContainer)),
                  title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(contact.phoneNumber),
                  trailing: IconButton(
                    icon: Icon(Icons.delete_outline, color: colorScheme.error),
                    onPressed: () => context.read<EmergencyContactsBloc>().add(
                          EmergencyContactDeleteRequested(contactId: contact.id, userId: 'mock_user'),
                        ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Add Emergency Contact'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
        const SizedBox(height: 12),
        TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Phone')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(onPressed: () {
          if (nameCtrl.text.isNotEmpty && phoneCtrl.text.isNotEmpty) {
            Navigator.pop(ctx);
            context.read<EmergencyContactsBloc>().add(EmergencyContactAddRequested(
                  userId: 'mock_user', name: nameCtrl.text, phoneNumber: phoneCtrl.text));
          }
        }, child: const Text('Add')),
      ],
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../bloc/support_bloc.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Support')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateTicketDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('New Ticket'),
      ),
      body: BlocConsumer<SupportBloc, SupportState>(
        listener: (context, state) {
          if (state is SupportTicketCreated) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ticket created successfully')));
            context.read<SupportBloc>().add(const SupportTicketsLoadRequested('mock_user'));
          }
        },
        builder: (context, state) {
          if (state is SupportLoading || state is SupportCreating) return const Center(child: CircularProgressIndicator());

          final tickets = state is SupportTicketsLoaded ? state.tickets : <SupportTicketEntity>[];

          if (tickets.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.support_agent_outlined, size: 48, color: colorScheme.outline),
              const SizedBox(height: 12),
              Text('No support tickets', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline)),
              const SizedBox(height: 8),
              Text('Create one if you need help', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.outline)),
            ]));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              final statusColor = switch (ticket.status) {
                AppConstants.ticketPending => const Color(0xFFD19D00),
                AppConstants.ticketActive => const Color(0xFF1976D2),
                AppConstants.ticketComplete => const Color(0xFF27C041),
                _ => const Color(0xFF9D9D9D),
              };
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(ticket.subject, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(ticket.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: Text(ticket.status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  onTap: () => context.read<SupportBloc>().add(SupportTicketDetailRequested(ticket.id)),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showCreateTicketDialog(BuildContext context) {
    final subjectCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Create Support Ticket'),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: subjectCtrl, decoration: const InputDecoration(labelText: 'Subject')),
        const SizedBox(height: 12),
        TextField(controller: descCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Description')),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(onPressed: () {
          if (subjectCtrl.text.isNotEmpty && descCtrl.text.isNotEmpty) {
            Navigator.pop(ctx);
            context.read<SupportBloc>().add(SupportTicketCreateRequested(
                  userId: 'mock_user', subject: subjectCtrl.text, description: descCtrl.text, reason: 'General'));
          }
        }, child: const Text('Submit')),
      ],
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../bloc/sos_bloc.dart';

class SosPage extends StatelessWidget {
  const SosPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('SOS Alerts')),
      body: BlocConsumer<SosBloc, SosState>(
        listener: (context, state) {
          if (state is SosAlertSent) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('SOS alert sent to your emergency contacts')));
          }
        },
        builder: (context, state) {
          if (state is SosLoading) return const Center(child: CircularProgressIndicator());
          final alerts = state is SosHistoryLoaded ? state.alerts : <SosAlertEntity>[];

          return Column(children: [
            // SOS info
            Container(
              margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: colorScheme.error.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colorScheme.error.withValues(alpha: 0.2))),
              child: Column(children: [
                Icon(Icons.warning_amber_rounded, size: 48, color: colorScheme.error),
                const SizedBox(height: 12),
                Text('Emergency SOS', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.error)),
                const SizedBox(height: 8),
                Text('This will alert your emergency contacts with your current location. For immediate danger, call your local emergency number.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7)), textAlign: TextAlign.center),
                const SizedBox(height: 16),
                Text('Emergency: 112 / 911', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ]),
            ),

            // History
            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Align(alignment: Alignment.centerLeft,
                child: Text('Alert History', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)))),
            const SizedBox(height: 8),

            Expanded(child: alerts.isEmpty
                ? Center(child: Text('No SOS alerts triggered', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: alerts.length,
                    itemBuilder: (context, index) {
                      final alert = alerts[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(Icons.sos, color: colorScheme.error),
                          title: Text('Alert #${alert.id.substring(alert.id.length - 6)}'),
                          subtitle: Text('${alert.createdAt.day}/${alert.createdAt.month}/${alert.createdAt.year} ${alert.createdAt.hour}:${alert.createdAt.minute.toString().padLeft(2, '0')}'),
                          trailing: Text(alert.location.address.isNotEmpty ? alert.location.address : 'Location sent'),
                        ),
                      );
                    },
                  )),
          ]);
        },
      ),
    );
  }
}

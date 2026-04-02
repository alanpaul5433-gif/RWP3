import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../bloc/zones_bloc.dart';

class ZonesPage extends StatelessWidget {
  const ZonesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('Zones', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const Spacer(),
        FilledButton.icon(onPressed: () => _showAddDialog(context), icon: const Icon(Icons.add), label: const Text('Add Zone')),
      ]),
      const SizedBox(height: 24),

      Expanded(child: BlocBuilder<ZonesBloc, ZonesState>(
        builder: (context, state) {
          if (state is ZonesLoading) return const Center(child: CircularProgressIndicator());
          final zones = state is ZonesLoaded ? state.zones : <ZoneEntity>[];

          if (zones.isEmpty) return Center(child: Text('No zones configured', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline)));

          return ListView.builder(itemCount: zones.length, itemBuilder: (context, index) {
            final zone = zones[index];
            return Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(
              leading: Icon(Icons.location_on, color: zone.isActive ? const Color(0xFF27C041) : colorScheme.outline),
              title: Text(zone.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text('${zone.coordinates.length} polygon points'),
              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: zone.isActive ? const Color(0xFF27C041).withValues(alpha: 0.1) : colorScheme.outline.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: Text(zone.isActive ? 'Active' : 'Inactive', style: TextStyle(color: zone.isActive ? const Color(0xFF27C041) : colorScheme.outline, fontSize: 12, fontWeight: FontWeight.w600))),
                const SizedBox(width: 8),
                IconButton(icon: Icon(Icons.delete_outline, color: colorScheme.error),
                    onPressed: () => context.read<ZonesBloc>().add(ZoneDeleteRequested(zone.id))),
              ]),
            ));
          });
        },
      )),
    ]));
  }

  void _showAddDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Add Zone'),
      content: TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Zone Name')),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        FilledButton(onPressed: () {
          if (nameCtrl.text.isNotEmpty) {
            Navigator.pop(ctx);
            context.read<ZonesBloc>().add(ZoneCreateRequested(ZoneEntity(id: '', name: nameCtrl.text, coordinates: const [
              LocationLatLng(latitude: 37.77, longitude: -122.42),
              LocationLatLng(latitude: 37.78, longitude: -122.41),
              LocationLatLng(latitude: 37.77, longitude: -122.40),
            ])));
          }
        }, child: const Text('Create')),
      ],
    ));
  }
}

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

    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Service Zones', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(width: 12),
              Text('Define operational areas for ride dispatch', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4))),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => _showAddZoneDialog(context),
                icon: const Icon(Icons.add_location_alt, size: 18),
                label: const Text('Add Zone'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Expanded(
            child: BlocBuilder<ZonesBloc, ZonesState>(
              builder: (context, state) {
                if (state is ZonesLoading) return const Center(child: CircularProgressIndicator());
                if (state is ZonesError) return Center(child: Text(state.message));
                final zones = state is ZonesLoaded ? state.zones : <ZoneEntity>[];

                if (zones.isEmpty) return Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.location_off, size: 64, color: colorScheme.onSurface.withValues(alpha: 0.15)),
                  const SizedBox(height: 12),
                  Text('No zones configured', style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.3))),
                ]));

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Zone list
                    SizedBox(
                      width: 380,
                      child: ListView.builder(
                        itemCount: zones.length,
                        itemBuilder: (context, index) {
                          final zone = zones[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: zone.isActive ? const Color(0xFF2E7D32).withValues(alpha: 0.3) : const Color(0xFFE8E5E0)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: zone.isActive ? const Color(0xFF2E7D32).withValues(alpha: 0.1) : const Color(0xFFF5F2ED),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(Icons.location_on, size: 18, color: zone.isActive ? const Color(0xFF2E7D32) : colorScheme.onSurface.withValues(alpha: 0.3)),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(zone.name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                                          Text(
                                            zone.type == 'circle' ? 'Radius: ${zone.radiusKm} km' : '${zone.coordinates.length} polygon points',
                                            style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Switch(
                                      value: zone.isActive,
                                      activeColor: const Color(0xFF2E7D32),
                                      onChanged: (_) => context.read<ZonesBloc>().add(ZoneToggleRequested(zone.id)),
                                    ),
                                  ],
                                ),
                                if (zone.center != null) ...[
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Icon(Icons.gps_fixed, size: 12, color: colorScheme.onSurface.withValues(alpha: 0.3)),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Center: ${zone.center!.latitude.toStringAsFixed(4)}, ${zone.center!.longitude.toStringAsFixed(4)}',
                                        style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4)),
                                      ),
                                    ],
                                  ),
                                ],
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    OutlinedButton.icon(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 34), padding: const EdgeInsets.symmetric(horizontal: 12), side: const BorderSide(color: Color(0xFFE8E5E0))),
                                      icon: const Icon(Icons.edit_outlined, size: 14),
                                      label: const Text('Edit', style: TextStyle(fontSize: 12)),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedButton.icon(
                                      onPressed: () => context.read<ZonesBloc>().add(ZoneDeleteRequested(zone.id)),
                                      style: OutlinedButton.styleFrom(minimumSize: const Size(0, 34), padding: const EdgeInsets.symmetric(horizontal: 12),
                                          foregroundColor: colorScheme.error, side: BorderSide(color: colorScheme.error.withValues(alpha: 0.3))),
                                      icon: const Icon(Icons.delete_outline, size: 14),
                                      label: const Text('Delete', style: TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 24),

                    // Map placeholder
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.map_outlined, size: 80, color: colorScheme.onSurface.withValues(alpha: 0.1)),
                              const SizedBox(height: 12),
                              Text('Zone Map Preview', style: theme.textTheme.titleMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.3))),
                              const SizedBox(height: 4),
                              Text('Google Maps will render zones here', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.2))),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddZoneDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final latCtrl = TextEditingController(text: '37.7749');
    final lngCtrl = TextEditingController(text: '-122.4194');
    final radiusCtrl = TextEditingController(text: '10.0');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Create Service Zone'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Zone Name', hintText: 'e.g. Downtown SF')),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: TextField(controller: latCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Center Latitude'))),
                const SizedBox(width: 12),
                Expanded(child: TextField(controller: lngCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Center Longitude'))),
              ]),
              const SizedBox(height: 16),
              TextField(controller: radiusCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Radius (km)', suffixText: 'km')),
              const SizedBox(height: 12),
              Text('The zone will cover a circular area around the center point with the specified radius.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4))),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty) return;
              final lat = double.tryParse(latCtrl.text) ?? 0;
              final lng = double.tryParse(lngCtrl.text) ?? 0;
              final radius = double.tryParse(radiusCtrl.text) ?? 10;
              Navigator.pop(ctx);
              context.read<ZonesBloc>().add(ZoneCreateRequested(ZoneEntity(
                id: '', name: nameCtrl.text,
                center: LocationLatLng(latitude: lat, longitude: lng),
                radiusKm: radius, type: 'circle',
              )));
            },
            child: const Text('Create Zone'),
          ),
        ],
      ),
    );
  }
}

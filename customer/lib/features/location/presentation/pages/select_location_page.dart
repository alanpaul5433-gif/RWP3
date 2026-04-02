import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../bloc/location_bloc.dart';

class SelectLocationPage extends StatelessWidget {
  const SelectLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
      ),
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          if (state is RouteCalculated) {
            context.push('/select-vehicle');
          } else if (state is LocationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: colorScheme.error),
            );
          }
        },
        builder: (context, state) {
          final pickup = state is LocationObtained ? state.pickup : null;
          final drop = state is LocationObtained ? state.drop : null;
          final stops = state is LocationObtained ? state.stops : <LocationLatLng>[];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Placeholder for map (Google Maps will be added with Firebase)
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.map_outlined, size: 64, color: colorScheme.outline),
                          const SizedBox(height: 8),
                          Text(
                            'Map will appear here',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                          if (pickup != null) ...[
                            const SizedBox(height: 8),
                            Text('Pickup: ${pickup.address}',
                                style: theme.textTheme.bodySmall),
                          ],
                          if (drop != null) ...[
                            const SizedBox(height: 4),
                            Text('Drop: ${drop.address}',
                                style: theme.textTheme.bodySmall),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Location input cards
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Pickup
                        _LocationInput(
                          icon: Icons.circle,
                          iconColor: const Color(0xFF27C041),
                          label: pickup?.address ?? 'Set pickup location',
                          onTap: () {
                            // Mock: set pickup to current location
                            context
                                .read<LocationBloc>()
                                .add(const CurrentLocationRequested());
                          },
                        ),
                        const Divider(height: 24),

                        // Drop
                        _LocationInput(
                          icon: Icons.circle,
                          iconColor: colorScheme.primary,
                          label: drop?.address ?? 'Where to?',
                          onTap: () {
                            // Mock: set a drop location
                            context.read<LocationBloc>().add(
                                  const DropLocationSet(LocationLatLng(
                                    latitude: 37.7849,
                                    longitude: -122.4094,
                                    address: '456 Mission St, San Francisco, CA',
                                  )),
                                );
                          },
                        ),

                        // Stops
                        if (stops.isNotEmpty) ...[
                          const Divider(height: 24),
                          ...stops.asMap().entries.map((entry) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Icon(Icons.circle_outlined,
                                        size: 12, color: colorScheme.secondary),
                                    const SizedBox(width: 12),
                                    Expanded(
                                        child: Text(entry.value.address,
                                            style: theme.textTheme.bodyMedium)),
                                    IconButton(
                                      icon: const Icon(Icons.close, size: 18),
                                      onPressed: () => context
                                          .read<LocationBloc>()
                                          .add(StopRemoved(entry.key)),
                                    ),
                                  ],
                                ),
                              )),
                        ],

                        // Add stop button
                        TextButton.icon(
                          onPressed: () {
                            context.read<LocationBloc>().add(
                                  const StopAdded(LocationLatLng(
                                    latitude: 37.7800,
                                    longitude: -122.4150,
                                    address: '789 Howard St, San Francisco, CA',
                                  )),
                                );
                          },
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add stop'),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Calculate route button
                FilledButton(
                  onPressed: (pickup != null && drop != null)
                      ? () => context
                          .read<LocationBloc>()
                          .add(const RouteCalculationRequested())
                      : null,
                  child: state is RouteCalculating
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Find Rides'),
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LocationInput extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  const _LocationInput({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 12, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

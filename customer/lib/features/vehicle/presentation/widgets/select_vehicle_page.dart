import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../../../location/presentation/bloc/location_bloc.dart';
import '../bloc/vehicle_bloc.dart';

class SelectVehiclePage extends StatelessWidget {
  const SelectVehiclePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Vehicle'),
      ),
      body: BlocConsumer<VehicleBloc, VehicleState>(
        listener: (context, state) {
          if (state is VehicleTypeChosen) {
            // Estimate fare with chosen vehicle
            context
                .read<LocationBloc>()
                .add(FareEstimationRequested(state.vehicleType));
          }
        },
        builder: (context, state) {
          if (state is VehicleLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is VehicleError) {
            return Center(child: Text(state.message));
          }

          final types =
              state is VehicleTypesLoaded ? state.types : <VehicleTypeEntity>[];

          return Column(
            children: [
              // Route summary
              BlocBuilder<LocationBloc, LocationState>(
                builder: (context, locState) {
                  if (locState is! RouteCalculated &&
                      locState is! FareEstimated) {
                    return const SizedBox.shrink();
                  }
                  final distance = locState is RouteCalculated
                      ? locState.distance
                      : (locState as FareEstimated).distance;

                  return Container(
                    padding: const EdgeInsets.all(16),
                    color: colorScheme.surfaceContainerHighest,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _InfoChip(
                          icon: Icons.straighten,
                          label:
                              '${distance.distanceInKm.toStringAsFixed(1)} km',
                        ),
                        _InfoChip(
                          icon: Icons.access_time,
                          label:
                              '${distance.durationInMinutes.toStringAsFixed(0)} min',
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Vehicle type list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: types.length,
                  itemBuilder: (context, index) {
                    final vehicle = types[index];
                    return _VehicleCard(
                      vehicle: vehicle,
                      onTap: () {
                        context
                            .read<VehicleBloc>()
                            .add(VehicleTypeSelected(vehicle));
                      },
                    );
                  },
                ),
              ),

              // Fare estimate and confirm
              BlocBuilder<LocationBloc, LocationState>(
                builder: (context, locState) {
                  if (locState is! FareEstimated) return const SizedBox.shrink();

                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Estimated Fare',
                                  style: theme.textTheme.titleMedium),
                              Text(
                                '\$${locState.fare.totalAmount.toStringAsFixed(2)}',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          FilledButton(
                            onPressed: () => context.push('/confirm-booking'),
                            child: const Text('Choose Payment & Book'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final VehicleTypeEntity vehicle;
  final VoidCallback onTap;

  const _VehicleCard({required this.vehicle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.directions_car,
                    color: colorScheme.onPrimaryContainer),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(vehicle.name,
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text(
                      '${vehicle.persons} seats',
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.5)),
                    ),
                  ],
                ),
              ),
              Text(
                '\$${vehicle.baseFare.toStringAsFixed(0)}+',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}

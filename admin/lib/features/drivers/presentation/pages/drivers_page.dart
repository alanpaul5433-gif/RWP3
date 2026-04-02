import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/drivers_bloc.dart';

class DriversPage extends StatelessWidget {
  const DriversPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Drivers', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'all', label: Text('All')),
                  ButtonSegment(value: 'unverified', label: Text('Unverified')),
                  ButtonSegment(value: 'online', label: Text('Online')),
                ],
                selected: const {'all'},
                onSelectionChanged: (selection) {
                  final filter = selection.first;
                  if (filter == 'unverified') {
                    context.read<DriversBloc>().add(const UnverifiedDriversRequested());
                  } else if (filter == 'online') {
                    context.read<DriversBloc>().add(const OnlineDriversRequested());
                  } else {
                    context.read<DriversBloc>().add(const DriversLoadRequested());
                  }
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: BlocBuilder<DriversBloc, DriversState>(
              builder: (context, state) {
                if (state is DriversLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DriversError) {
                  return Center(child: Text(state.message));
                }
                if (state is DriverVerified) {
                  // Show success then reload
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${state.driver.fullName} verified successfully')),
                    );
                    context.read<DriversBloc>().add(const DriversLoadRequested());
                  });
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is! DriversLoaded) return const SizedBox.shrink();

                return Card(
                  child: SizedBox(
                    width: double.infinity,
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Name')),
                          DataColumn(label: Text('Vehicle')),
                          DataColumn(label: Text('Rating')),
                          DataColumn(label: Text('Earnings')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: state.drivers.map((d) => DataRow(cells: [
                          DataCell(Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(d.fullName, style: const TextStyle(fontWeight: FontWeight.w500)),
                              Text(d.email, style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5))),
                            ],
                          )),
                          DataCell(Text('${d.vehicleTypeName} - ${d.vehicleNumber}')),
                          DataCell(Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: Color(0xFFFFC107), size: 16),
                              const SizedBox(width: 4),
                              Text(d.averageRating.toStringAsFixed(1)),
                            ],
                          )),
                          DataCell(Text('\$${d.totalEarning.toStringAsFixed(0)}')),
                          DataCell(Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _Badge(d.isVerified ? 'Verified' : 'Pending', d.isVerified ? const Color(0xFF27C041) : const Color(0xFFD19D00)),
                              if (d.isOnline) ...[
                                const SizedBox(width: 4),
                                _Badge('Online', const Color(0xFF1976D2)),
                              ],
                            ],
                          )),
                          DataCell(!d.isVerified
                              ? FilledButton.tonal(
                                  onPressed: () => context.read<DriversBloc>().add(DriverVerifyRequested(d.id)),
                                  child: const Text('Verify'),
                                )
                              : const SizedBox.shrink()),
                        ])).toList(),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

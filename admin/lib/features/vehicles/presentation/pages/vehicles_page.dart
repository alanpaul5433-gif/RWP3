import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../bloc/vehicles_bloc.dart';

class VehiclesPage extends StatelessWidget {
  const VehiclesPage({super.key});

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
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Vehicle Management', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                Text('Configure vehicle types, pricing, and brands', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4))),
              ]),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => _showTypeDialog(context, null),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Vehicle Type'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Expanded(
            child: BlocBuilder<VehiclesBloc, VehiclesState>(
              builder: (context, state) {
                if (state is VehiclesLoading) return const Center(child: CircularProgressIndicator());
                if (state is VehiclesError) return Center(child: Text(state.message));
                if (state is! VehiclesLoaded) return const SizedBox.shrink();

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Vehicle Types Table
                    Expanded(
                      flex: 3,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Vehicle Types', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(height: 16),
                            Expanded(
                              child: SingleChildScrollView(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: DataTable(
                                    columnSpacing: 16,
                                    columns: const [
                                      DataColumn(label: Text('TYPE')),
                                      DataColumn(label: Text('SEATS')),
                                      DataColumn(label: Text('BASE FARE')),
                                      DataColumn(label: Text('PER KM')),
                                      DataColumn(label: Text('PER MIN')),
                                      DataColumn(label: Text('MIN FARE')),
                                      DataColumn(label: Text('ACTIONS')),
                                    ],
                                    rows: state.types.map((t) => DataRow(cells: [
                                      DataCell(Row(children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                                          child: Icon(Icons.directions_car, size: 16, color: colorScheme.primary),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(t.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                      ])),
                                      DataCell(Text('${t.persons}')),
                                      DataCell(Text('\$${t.baseFare.toStringAsFixed(2)}')),
                                      DataCell(Text('\$${t.perKmRate.toStringAsFixed(2)}')),
                                      DataCell(Text('\$${t.perMinuteRate.toStringAsFixed(2)}')),
                                      DataCell(Text('\$${t.minimumFare.toStringAsFixed(2)}')),
                                      DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                                        InkWell(
                                          onTap: () => _showTypeDialog(context, t),
                                          child: Padding(padding: const EdgeInsets.all(6), child: Icon(Icons.edit_outlined, size: 16, color: colorScheme.primary)),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            context.read<VehiclesBloc>().add(VehicleTypeDeleteRequested(t.id));
                                          },
                                          child: Padding(padding: const EdgeInsets.all(6), child: Icon(Icons.delete_outline, size: 16, color: colorScheme.error)),
                                        ),
                                      ])),
                                    ])).toList(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Brands sidebar
                    SizedBox(
                      width: 260,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              Text('Brands', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                              const Spacer(),
                              IconButton(
                                onPressed: () => _showAddBrand(context),
                                icon: Icon(Icons.add_circle_outline, size: 20, color: colorScheme.primary),
                              ),
                            ]),
                            const SizedBox(height: 12),
                            Expanded(
                              child: ListView.builder(
                                itemCount: state.brands.length,
                                itemBuilder: (context, i) {
                                  final brand = state.brands[i];
                                  final typeName = state.types.where((t) => t.id == brand['type']).firstOrNull?.name ?? 'Unknown';
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F2ED),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(children: [
                                      Expanded(child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(brand['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                          Text(typeName, style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4))),
                                        ],
                                      )),
                                      Icon(Icons.chevron_right, size: 16, color: colorScheme.onSurface.withValues(alpha: 0.3)),
                                    ]),
                                  );
                                },
                              ),
                            ),
                          ],
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

  void _showTypeDialog(BuildContext context, VehicleTypeEntity? existing) {
    final isEdit = existing != null;
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final seatsCtrl = TextEditingController(text: '${existing?.persons ?? 4}');
    final baseCtrl = TextEditingController(text: existing?.baseFare.toStringAsFixed(2) ?? '');
    final kmCtrl = TextEditingController(text: existing?.perKmRate.toStringAsFixed(2) ?? '');
    final minCtrl = TextEditingController(text: existing?.perMinuteRate.toStringAsFixed(2) ?? '');
    final minFareCtrl = TextEditingController(text: existing?.minimumFare.toStringAsFixed(2) ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isEdit ? 'Edit Vehicle Type' : 'Add Vehicle Type'),
        content: SizedBox(
          width: 420,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Type Name', hintText: 'e.g. Premium Sedan')),
            const SizedBox(height: 12),
            TextField(controller: seatsCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Seats')),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextField(controller: baseCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Base Fare (\$)'))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: kmCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Per KM (\$)'))),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: TextField(controller: minCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Per Minute (\$)'))),
              const SizedBox(width: 12),
              Expanded(child: TextField(controller: minFareCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Minimum Fare (\$)'))),
            ]),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final type = VehicleTypeEntity(
                id: existing?.id ?? '', name: nameCtrl.text,
                persons: int.tryParse(seatsCtrl.text) ?? 4,
                baseFare: double.tryParse(baseCtrl.text) ?? 0,
                perKmRate: double.tryParse(kmCtrl.text) ?? 0,
                perMinuteRate: double.tryParse(minCtrl.text) ?? 0,
                minimumFare: double.tryParse(minFareCtrl.text) ?? 0,
              );
              Navigator.pop(ctx);
              if (isEdit) {
                context.read<VehiclesBloc>().add(VehicleTypeUpdateRequested(type));
              } else {
                context.read<VehiclesBloc>().add(VehicleTypeCreateRequested(type));
              }
            },
            child: Text(isEdit ? 'Update' : 'Create'),
          ),
        ],
      ),
    );
  }

  void _showAddBrand(BuildContext context) {
    final nameCtrl = TextEditingController();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Add Brand — will connect to Firebase for live data')));
  }
}

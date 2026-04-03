import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../bloc/drivers_bloc.dart';

class DriversPage extends StatefulWidget {
  const DriversPage({super.key});

  @override
  State<DriversPage> createState() => _DriversPageState();
}

class _DriversPageState extends State<DriversPage> {
  String _filter = 'all';

  void _applyFilter(String filter) {
    setState(() => _filter = filter);
    final bloc = context.read<DriversBloc>();
    switch (filter) {
      case 'unverified': bloc.add(const UnverifiedDriversRequested());
      case 'online': bloc.add(const OnlineDriversRequested());
      default: bloc.add(const DriversLoadRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Drivers', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                  Text('Manage and monitor your fleet\'s active workforce.', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4))),
                ],
              ),
              const Spacer(),
              // Filter chips
              ...['all', 'unverified', 'online'].map((f) => Padding(
                padding: const EdgeInsets.only(left: 8),
                child: ChoiceChip(
                  label: Text(f == 'all' ? 'All' : f == 'unverified' ? 'Unverified' : 'Online'),
                  selected: _filter == f,
                  onSelected: (_) => _applyFilter(f),
                  selectedColor: colorScheme.primary.withValues(alpha: 0.1),
                  labelStyle: TextStyle(
                    color: _filter == f ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: _filter == f ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              )),
            ],
          ),
          const SizedBox(height: 24),

          // Table
          Expanded(
            child: BlocConsumer<DriversBloc, DriversState>(
              listener: (context, state) {
                if (state is DriverVerified) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${state.driver.fullName} verified successfully')));
                  context.read<DriversBloc>().add(const DriversLoadRequested());
                }
              },
              builder: (context, state) {
                if (state is DriversLoading) return const Center(child: CircularProgressIndicator());
                if (state is DriversError) return Center(child: Text(state.message));
                if (state is! DriversLoaded) return const SizedBox.shrink();

                return Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: DataTable(
                        columnSpacing: 20,
                        columns: const [
                          DataColumn(label: Text('DRIVER')),
                          DataColumn(label: Text('VEHICLE')),
                          DataColumn(label: Text('STATUS')),
                          DataColumn(label: Text('RATING')),
                          DataColumn(label: Text('EARNINGS')),
                          DataColumn(label: Text('BG CHECK')),
                          DataColumn(label: Text('ACTIONS')),
                        ],
                        rows: state.drivers.map((d) => DataRow(cells: [
                          DataCell(Row(children: [
                            CircleAvatar(radius: 18, backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                                child: Icon(Icons.person, size: 18, color: colorScheme.primary)),
                            const SizedBox(width: 10),
                            Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text(d.fullName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              Text(d.email, style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4))),
                            ]),
                          ])),
                          DataCell(Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text(d.vehicleTypeName, style: const TextStyle(fontSize: 13)),
                            Text(d.vehicleNumber, style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4))),
                          ])),
                          DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                            _Badge(d.isVerified ? 'Verified' : 'Pending', d.isVerified ? const Color(0xFF2E7D32) : const Color(0xFFDAA520)),
                            if (d.isOnline) ...[const SizedBox(width: 6), _Badge('Online', const Color(0xFF1976D2))],
                          ])),
                          DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                            const Icon(Icons.star, color: Color(0xFFDAA520), size: 14),
                            const SizedBox(width: 4),
                            Text(d.averageRating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                          ])),
                          DataCell(Text('\$${d.totalEarning.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600))),
                          DataCell(_Badge(
                            d.isVerified ? 'Cleared' : 'Pending',
                            d.isVerified ? const Color(0xFF2E7D32) : const Color(0xFFE65100),
                          )),
                          DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                            _ActionIcon(Icons.visibility_outlined, const Color(0xFF1976D2), () => _showDriverDetail(context, d)),
                            if (!d.isVerified)
                              _ActionIcon(Icons.check_circle_outline, const Color(0xFF2E7D32), () => _showVerifyConfirm(context, d)),
                            _ActionIcon(Icons.edit_outlined, colorScheme.onSurface.withValues(alpha: 0.4), () => _showEditDialog(context, d)),
                          ])),
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

  void _showDriverDetail(BuildContext context, DriverEntity d) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          CircleAvatar(radius: 24, backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
              child: Icon(Icons.person, color: colorScheme.primary, size: 24)),
          const SizedBox(width: 14),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d.fullName, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            Text(d.email, style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5))),
          ]),
        ]),
        content: SizedBox(
          width: 420,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Divider(),
            _DetailRow('Phone', d.phoneNumber.isNotEmpty ? d.phoneNumber : 'Not provided'),
            _DetailRow('Vehicle', '${d.vehicleTypeName} - ${d.vehicleNumber}'),
            _DetailRow('Rating', '${d.averageRating.toStringAsFixed(1)} / 5.0'),
            _DetailRow('Total Earnings', '\$${d.totalEarning.toStringAsFixed(2)}'),
            _DetailRow('Status', d.isVerified ? 'Verified' : 'Pending Verification'),
            _DetailRow('Online', d.isOnline ? 'Yes' : 'No'),
            _DetailRow('Background Check', d.isVerified ? 'CLEARED' : 'PENDING REVIEW'),
            const Divider(),
            const SizedBox(height: 8),
            Text('DOCUMENTS', style: theme.textTheme.labelSmall?.copyWith(letterSpacing: 1, color: colorScheme.onSurface.withValues(alpha: 0.4))),
            const SizedBox(height: 8),
            _DocStatus("Driver's License", d.isVerified),
            _DocStatus('ID Proof', d.isVerified),
            _DocStatus('Vehicle Insurance', d.isVerified),
            _DocStatus('Background Check', d.isVerified),
          ]),
        ),
        actions: [
          if (!d.isVerified)
            FilledButton.icon(
              onPressed: () { Navigator.pop(ctx); _showVerifyConfirm(context, d); },
              icon: const Icon(Icons.check, size: 16),
              label: const Text('Approve Driver'),
            ),
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showVerifyConfirm(BuildContext context, DriverEntity d) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Verify Driver'),
        content: Text('This will mark ${d.fullName} as verified and clear their background check. They will be able to accept rides immediately.\n\nProceed?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () { Navigator.pop(ctx); context.read<DriversBloc>().add(DriverVerifyRequested(d.id)); },
            child: const Text('Verify & Clear'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, DriverEntity d) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Edit ${d.fullName} — will connect to Firebase for live updates')));
  }
}

class _Badge extends StatelessWidget {
  final String label; final Color color;
  const _Badge(this.label, this.color);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
    child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
  );
}

class _ActionIcon extends StatelessWidget {
  final IconData icon; final Color color; final VoidCallback onTap;
  const _ActionIcon(this.icon, this.color, this.onTap);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 4),
    child: InkWell(onTap: onTap, borderRadius: BorderRadius.circular(8),
        child: Padding(padding: const EdgeInsets.all(6), child: Icon(icon, size: 18, color: color))),
  );
}

class _DetailRow extends StatelessWidget {
  final String label; final String value;
  const _DetailRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
      Text(value, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
    ]),
  );
}

class _DocStatus extends StatelessWidget {
  final String name; final bool verified;
  const _DocStatus(this.name, this.verified);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(children: [
      Icon(verified ? Icons.check_circle : Icons.pending, size: 16, color: verified ? const Color(0xFF2E7D32) : const Color(0xFFDAA520)),
      const SizedBox(width: 8),
      Text(name, style: Theme.of(context).textTheme.bodySmall),
      const Spacer(),
      Text(verified ? 'Verified' : 'Pending', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
          color: verified ? const Color(0xFF2E7D32) : const Color(0xFFDAA520))),
    ]),
  );
}

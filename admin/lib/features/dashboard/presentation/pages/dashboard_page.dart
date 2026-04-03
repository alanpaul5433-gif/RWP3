import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../bloc/dashboard_bloc.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoading || state is DashboardInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DashboardError) return Center(child: Text(state.message));
        if (state is! DashboardLoaded) return const SizedBox.shrink();

        final stats = state.stats;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================== Header ====================
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Platform Overview', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 2),
                      Text('Real-time fleet analytics', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4))),
                    ],
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () {},
                    style: FilledButton.styleFrom(minimumSize: const Size(140, 44)),
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Export Rep'),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ==================== Stat Cards ====================
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _StatCard(
                    label: 'TOTAL USERS',
                    value: '${stats.totalCustomers}',
                    icon: Icons.people,
                    iconBg: const Color(0xFF1976D2),
                    change: '+10.8%',
                  ),
                  _StatCard(
                    label: 'ACTIVE DRIVERS',
                    value: '${stats.totalDrivers}',
                    icon: Icons.drive_eta,
                    iconBg: const Color(0xFF2E7D32),
                    badge: 'Live Now',
                  ),
                  _StatCard(
                    label: 'ONGOING RIDES',
                    value: '${stats.activeBookings}',
                    icon: Icons.local_taxi,
                    iconBg: const Color(0xFFE65100),
                  ),
                  _EarningsCard(value: stats.todayEarnings),
                ],
              ),

              const SizedBox(height: 28),

              // ==================== Revenue + Service Health ====================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Revenue chart placeholder
                  Expanded(
                    flex: 3,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text('Revenue Growth', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: const Color(0xFFF5F2ED), borderRadius: BorderRadius.circular(8)),
                                child: Text('Last 7 Days', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
                              ),
                            ],
                          ),
                          Text('Weekly performance monitoring', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4))),
                          const SizedBox(height: 24),
                          // Chart placeholder
                          Container(
                            height: 160,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F2ED),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(child: Text('Revenue Chart', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.3)))),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Service Health
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Service Health', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 20),
                          _HealthRow('Server Load', '47%', 0.47, const Color(0xFF2E7D32)),
                          const SizedBox(height: 14),
                          _HealthRow('Driver Dispatch Rate', '93.5%', 0.935, const Color(0xFF1976D2)),
                          const SizedBox(height: 14),
                          _HealthRow('Average ETA', '4.2 min', 0.7, const Color(0xFFE65100)),
                          const SizedBox(height: 20),
                          OutlinedButton.icon(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 40), side: const BorderSide(color: Color(0xFFE8E5E0))),
                            icon: const Icon(Icons.monitor_heart_outlined, size: 16),
                            label: const Text('View System Logs'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // ==================== Live Bookings Table ====================
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Live Bookings', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: const Color(0xFF2E7D32).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                          child: const Text('LIVE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF2E7D32))),
                        ),
                        const Spacer(),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search ride ID...',
                              prefixIcon: const Icon(Icons.search, size: 18),
                              contentPadding: const EdgeInsets.symmetric(vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE8E5E0))),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE8E5E0))),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text('Monitoring real-time activity across all zones', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4))),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: DataTable(
                        columnSpacing: 24,
                        columns: const [
                          DataColumn(label: Text('RIDE')),
                          DataColumn(label: Text('CUSTOMER')),
                          DataColumn(label: Text('DRIVER')),
                          DataColumn(label: Text('ROUTE')),
                          DataColumn(label: Text('STATUS')),
                          DataColumn(label: Text('FARE')),
                        ],
                        rows: state.recentBookings.take(5).map((b) => DataRow(cells: [
                          DataCell(Text('#${b.id.substring(0, 8).toUpperCase()}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))),
                          DataCell(Text(b.customerId.length > 10 ? b.customerId.substring(0, 10) : b.customerId)),
                          DataCell(Text(b.driverName ?? 'Assigning...', style: TextStyle(color: b.driverName == null ? colorScheme.onSurface.withValues(alpha: 0.4) : null))),
                          DataCell(Text('${b.pickupLocation.address.split(',').first} \u2192 ${b.dropLocation.address.split(',').first}', overflow: TextOverflow.ellipsis)),
                          DataCell(_StatusBadge(b.bookingStatus)),
                          DataCell(Text('\$${b.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600))),
                        ])).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Text('VIEW ALL RECENT ACTIVITIES', style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconBg;
  final String? change;
  final String? badge;

  const _StatCard({required this.label, required this.value, required this.icon, required this.iconBg, this.change, this.badge});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 200,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: iconBg.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(icon, color: iconBg, size: 18),
                ),
                if (change != null) ...[
                  const Spacer(),
                  Text(change!, style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFF2E7D32), fontWeight: FontWeight.w600)),
                ],
                if (badge != null) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: const Color(0xFF2E7D32).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                    child: Text(badge!, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF2E7D32))),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4), letterSpacing: 0.5, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }
}

class _EarningsCard extends StatelessWidget {
  final double value;
  const _EarningsCard({required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 200,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFC41E24),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("TODAY'S EARNINGS", style: theme.textTheme.labelSmall?.copyWith(color: Colors.white.withValues(alpha: 0.6), letterSpacing: 0.5)),
            const SizedBox(height: 8),
            Text('\$${value.toStringAsFixed(2)}', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _HealthRow extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final Color color;
  const _HealthRow(this.label, this.value, this.progress, this.color);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
            Text(value, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: color)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: progress, backgroundColor: color.withValues(alpha: 0.1), valueColor: AlwaysStoppedAnimation(color), minHeight: 6),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      BookingStatus.placed => const Color(0xFF9E9E9E),
      BookingStatus.accepted || BookingStatus.driverAssigned => const Color(0xFF1976D2),
      BookingStatus.ongoing => const Color(0xFFE65100),
      BookingStatus.completed => const Color(0xFF2E7D32),
      BookingStatus.cancelled || BookingStatus.rejected => const Color(0xFFC41E24),
      _ => const Color(0xFF9E9E9E),
    };
    final label = switch (status) {
      BookingStatus.ongoing => 'In Transit',
      BookingStatus.completed => 'Completed',
      BookingStatus.driverAssigned => 'Dispatched',
      _ => status.replaceAll('booking_', '').replaceAll('_', ' '),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

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
        if (state is DashboardError) {
          return Center(child: Text(state.message));
        }
        if (state is! DashboardLoaded) return const SizedBox.shrink();

        final stats = state.stats;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dashboard', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),

              // Stats cards
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _StatCard(title: 'Total Customers', value: '${stats.totalCustomers}', icon: Icons.people, color: colorScheme.secondary),
                  _StatCard(title: 'Total Drivers', value: '${stats.totalDrivers}', icon: Icons.drive_eta, color: const Color(0xFF2E7D32)),
                  _StatCard(title: 'Total Bookings', value: '${stats.totalBookings}', icon: Icons.receipt_long, color: const Color(0xFFE65100)),
                  _StatCard(title: 'Active Rides', value: '${stats.activeBookings}', icon: Icons.local_taxi, color: colorScheme.primary),
                  _StatCard(title: "Today's Earnings", value: '\$${stats.todayEarnings.toStringAsFixed(0)}', icon: Icons.attach_money, color: const Color(0xFF27C041)),
                  _StatCard(title: 'Monthly Earnings', value: '\$${stats.monthlyEarnings.toStringAsFixed(0)}', icon: Icons.trending_up, color: const Color(0xFF1976D2)),
                ],
              ),

              const SizedBox(height: 32),

              // Recent bookings
              Text('Recent Bookings', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Card(
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Vehicle')),
                      DataColumn(label: Text('Amount')),
                    ],
                    rows: state.recentBookings.map((b) => DataRow(cells: [
                      DataCell(Text(b.id.length > 12 ? '${b.id.substring(0, 12)}...' : b.id)),
                      DataCell(_StatusChip(b.bookingStatus)),
                      DataCell(Text(b.vehicleTypeName)),
                      DataCell(Text('\$${b.totalAmount.toStringAsFixed(2)}')),
                    ])).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Recent customers
              Text('Recent Customers', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Card(
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Phone')),
                    ],
                    rows: state.recentCustomers.map((c) => DataRow(cells: [
                      DataCell(Text(c.fullName)),
                      DataCell(Text(c.email)),
                      DataCell(Text(c.phoneNumber)),
                    ])).toList(),
                  ),
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
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(title, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip(this.status);

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      BookingStatus.placed => const Color(0xFF9D9D9D),
      BookingStatus.accepted || BookingStatus.driverAssigned => const Color(0xFF1EADFF),
      BookingStatus.ongoing => const Color(0xFFD19D00),
      BookingStatus.completed => const Color(0xFF27C041),
      BookingStatus.cancelled || BookingStatus.rejected => const Color(0xFFFE7235),
      _ => const Color(0xFF9D9D9D),
    };

    final label = status.replaceAll('booking_', '').replaceAll('_', ' ');
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

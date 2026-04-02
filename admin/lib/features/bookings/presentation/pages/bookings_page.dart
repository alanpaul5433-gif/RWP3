import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../bloc/admin_bookings_bloc.dart';

class BookingsPage extends StatelessWidget {
  const BookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        Text('Bookings', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
        const Spacer(),
        SegmentedButton<String?>(
          segments: const [
            ButtonSegment(value: null, label: Text('All')),
            ButtonSegment(value: BookingStatus.placed, label: Text('Placed')),
            ButtonSegment(value: BookingStatus.ongoing, label: Text('Ongoing')),
            ButtonSegment(value: BookingStatus.completed, label: Text('Completed')),
            ButtonSegment(value: BookingStatus.cancelled, label: Text('Cancelled')),
          ],
          selected: const {null},
          onSelectionChanged: (s) => context.read<AdminBookingsBloc>().add(AdminBookingsFilterChanged(s.first)),
        ),
      ]),
      const SizedBox(height: 24),

      Expanded(child: BlocBuilder<AdminBookingsBloc, AdminBookingsState>(
        builder: (context, state) {
          if (state is AdminBookingsLoading) return const Center(child: CircularProgressIndicator());
          if (state is AdminBookingsError) return Center(child: Text(state.message));
          if (state is! AdminBookingsLoaded) return const SizedBox.shrink();

          return Card(child: SizedBox(width: double.infinity, child: SingleChildScrollView(child: DataTable(
            columns: const [
              DataColumn(label: Text('ID')), DataColumn(label: Text('Vehicle')), DataColumn(label: Text('Status')),
              DataColumn(label: Text('Payment')), DataColumn(label: Text('Amount')), DataColumn(label: Text('Date')),
            ],
            rows: state.bookings.map((b) {
              final statusColor = switch (b.bookingStatus) {
                BookingStatus.completed => const Color(0xFF27C041), BookingStatus.ongoing => const Color(0xFFD19D00),
                BookingStatus.cancelled => const Color(0xFFFE7235), _ => const Color(0xFF9D9D9D),
              };
              return DataRow(cells: [
                DataCell(Text(b.id.length > 14 ? '${b.id.substring(0, 14)}...' : b.id, style: theme.textTheme.bodySmall)),
                DataCell(Text(b.vehicleTypeName)),
                DataCell(Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: Text(b.bookingStatus.replaceAll('booking_', ''), style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600)))),
                DataCell(Text(b.paymentType)),
                DataCell(Text('\$${b.totalAmount.toStringAsFixed(2)}')),
                DataCell(Text('${b.createdAt.day}/${b.createdAt.month}', style: theme.textTheme.bodySmall)),
              ]);
            }).toList(),
          ))));
        },
      )),

      // Pagination info
      BlocBuilder<AdminBookingsBloc, AdminBookingsState>(
        builder: (context, state) {
          if (state is! AdminBookingsLoaded) return const SizedBox.shrink();
          return Padding(padding: const EdgeInsets.only(top: 12),
              child: Text('Showing ${state.bookings.length} of ${state.totalCount} bookings',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))));
        },
      ),
    ]));
  }
}

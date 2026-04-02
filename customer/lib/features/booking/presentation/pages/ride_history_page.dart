import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../bloc/booking_bloc.dart';

class RideHistoryPage extends StatefulWidget {
  const RideHistoryPage({super.key});

  @override
  State<RideHistoryPage> createState() => _RideHistoryPageState();
}

class _RideHistoryPageState extends State<RideHistoryPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _tabs = const ['Ongoing', 'Completed', 'Cancelled'];
  final _statuses = [BookingStatus.ongoing, BookingStatus.completed, BookingStatus.cancelled];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride History'),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs.map((t) => Tab(text: t)).toList(),
          labelColor: colorScheme.primary,
          indicatorColor: colorScheme.primary,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _statuses.map((status) => _RideList(status: status)).toList(),
      ),
    );
  }
}

class _RideList extends StatelessWidget {
  final String status;
  const _RideList({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<BookingBloc, BookingState>(
      builder: (context, state) {
        if (state is BookingHistoryLoaded && state.status == status) {
          final bookings = state.bookings;
          if (bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 48, color: colorScheme.outline),
                  const SizedBox(height: 12),
                  Text('No ${status.replaceAll('booking_', '')} rides', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline)),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) => _RideCard(booking: bookings[index]),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _RideCard extends StatelessWidget {
  final BookingEntity booking;
  const _RideCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final statusColor = _getStatusColor(booking.bookingStatus);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/ride-detail/${booking.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(booking.vehicleTypeName.isNotEmpty ? booking.vehicleTypeName : 'Ride',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: Text(booking.bookingStatus.replaceAll('booking_', ''),
                        style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: Color(0xFF27C041)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(booking.pickupLocation.address, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.circle, size: 8, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(booking.dropLocation.address, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('\$${booking.totalAmount > 0 ? booking.totalAmount.toStringAsFixed(2) : booking.estimatedFare.toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary)),
                  const Spacer(),
                  Text(_formatDate(booking.createdAt), style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) => switch (status) {
        BookingStatus.ongoing => const Color(0xFFD19D00),
        BookingStatus.completed => const Color(0xFF27C041),
        BookingStatus.cancelled => const Color(0xFFFE7235),
        _ => const Color(0xFF9D9D9D),
      };

  String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';
}

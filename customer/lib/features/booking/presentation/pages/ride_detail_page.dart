import 'package:flutter/material.dart';
import 'package:core/core.dart';

class RideDetailPage extends StatelessWidget {
  final BookingEntity booking;
  const RideDetailPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Ride Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: _statusColor(booking.bookingStatus).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(booking.bookingStatus.replaceAll('booking_', '').toUpperCase(),
                    style: TextStyle(color: _statusColor(booking.bookingStatus), fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(height: 24),

            // Route
            Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
              _LocationRow(Icons.circle, const Color(0xFF27C041), 'Pickup', booking.pickupLocation.address),
              const Padding(padding: EdgeInsets.only(left: 4), child: SizedBox(height: 24, child: VerticalDivider())),
              _LocationRow(Icons.circle, colorScheme.primary, 'Drop', booking.dropLocation.address),
              if (booking.stops.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('${booking.stops.length} stop(s)', style: theme.textTheme.bodySmall),
              ],
            ]))),
            const SizedBox(height: 16),

            // Details
            Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
              _DetailRow('Vehicle', booking.vehicleTypeName),
              if (booking.distanceKm > 0) _DetailRow('Distance', '${booking.distanceKm.toStringAsFixed(1)} km'),
              if (booking.durationMinutes > 0) _DetailRow('Duration', '${booking.durationMinutes.toStringAsFixed(0)} min'),
              _DetailRow('Payment', booking.paymentType.toUpperCase()),
              _DetailRow('Status', booking.paymentStatus ? 'Paid' : 'Pending'),
            ]))),
            const SizedBox(height: 16),

            // Fare
            Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Fare', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              if (booking.subTotal > 0) _DetailRow('Subtotal', '\$${booking.subTotal.toStringAsFixed(2)}'),
              if (booking.discount > 0) _DetailRow('Discount', '-\$${booking.discount.toStringAsFixed(2)}'),
              if (booking.nightCharge > 0) _DetailRow('Night charge', '\$${booking.nightCharge.toStringAsFixed(2)}'),
              if (booking.taxAmount > 0) _DetailRow('Tax', '\$${booking.taxAmount.toStringAsFixed(2)}'),
              const Divider(),
              _DetailRow('Total', '\$${(booking.totalAmount > 0 ? booking.totalAmount : booking.estimatedFare).toStringAsFixed(2)}', isBold: true),
            ]))),
            const SizedBox(height: 16),

            // Driver info
            if (booking.driverName != null)
              Card(child: ListTile(
                leading: CircleAvatar(backgroundColor: colorScheme.primaryContainer,
                    child: Icon(Icons.person, color: colorScheme.onPrimaryContainer)),
                title: Text(booking.driverName!, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(booking.driverVehicleNumber ?? ''),
              )),

            // Timestamps
            const SizedBox(height: 16),
            Card(child: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
              _DetailRow('Booked', _formatDateTime(booking.createdAt)),
              if (booking.pickupTime != null) _DetailRow('Pickup', _formatDateTime(booking.pickupTime!)),
              if (booking.dropTime != null) _DetailRow('Drop', _formatDateTime(booking.dropTime!)),
            ]))),

            if (booking.cancellationReason != null) ...[
              const SizedBox(height: 16),
              Card(
                color: colorScheme.error.withValues(alpha: 0.05),
                child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Cancellation', style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.error)),
                  const SizedBox(height: 8),
                  Text('Reason: ${booking.cancellationReason}'),
                  if (booking.cancelledBy != null) Text('By: ${booking.cancelledBy}'),
                ])),
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String s) => switch (s) {
        BookingStatus.completed => const Color(0xFF27C041),
        BookingStatus.ongoing => const Color(0xFFD19D00),
        BookingStatus.cancelled => const Color(0xFFFE7235),
        _ => const Color(0xFF9D9D9D),
      };

  String _formatDateTime(DateTime d) => '${d.day}/${d.month}/${d.year} ${d.hour}:${d.minute.toString().padLeft(2, '0')}';
}

class _LocationRow extends StatelessWidget {
  final IconData icon; final Color color; final String label; final String address;
  const _LocationRow(this.icon, this.color, this.label, this.address);

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, size: 10, color: color), const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5))),
          Text(address, style: Theme.of(context).textTheme.bodyMedium),
        ])),
      ]);
}

class _DetailRow extends StatelessWidget {
  final String label; final String value; final bool isBold;
  const _DetailRow(this.label, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    final style = isBold ? Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: style), Text(value, style: style)]));
  }
}

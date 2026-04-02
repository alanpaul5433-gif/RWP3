import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../../../booking/presentation/bloc/booking_bloc.dart';

class TrackingPage extends StatelessWidget {
  final String bookingId;
  const TrackingPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride Status'),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingCancelledState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Booking cancelled')),
            );
            context.go('/home');
          }
        },
        builder: (context, state) {
          BookingEntity? booking;
          if (state is BookingPlacedState) {
            booking = state.booking;
          } else if (state is BookingUpdated) {
            booking = state.booking;
          }

          if (booking == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Map placeholder
              Expanded(
                flex: 3,
                child: Container(
                  color: colorScheme.surfaceContainerHighest,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map_outlined, size: 64, color: colorScheme.outline),
                        const SizedBox(height: 8),
                        Text('Live tracking map',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurface.withValues(alpha: 0.5),
                            )),
                      ],
                    ),
                  ),
                ),
              ),

              // Booking info card
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _statusColor(booking.bookingStatus)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _statusLabel(booking.bookingStatus),
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: _statusColor(booking.bookingStatus),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Driver info (when assigned)
                      if (booking.driverName != null) ...[
                        Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: colorScheme.primaryContainer,
                              child: Icon(Icons.person,
                                  color: colorScheme.onPrimaryContainer),
                            ),
                            title: Text(booking.driverName!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            subtitle:
                                Text(booking.driverVehicleNumber ?? ''),
                            trailing: IconButton(
                              icon: Icon(Icons.phone,
                                  color: colorScheme.secondary),
                              tooltip: 'Call driver',
                              onPressed: () {},
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],

                      // OTP (when assigned, before ride starts)
                      if (booking.otp != null &&
                          (booking.bookingStatus ==
                                  BookingStatus.driverAssigned ||
                              booking.bookingStatus ==
                                  BookingStatus.accepted)) ...[
                        Card(
                          color: colorScheme.secondaryContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Share OTP with driver: ',
                                    style: theme.textTheme.bodyMedium),
                                Text(
                                  booking.otp!,
                                  style:
                                      theme.textTheme.headlineMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 4,
                                    color: colorScheme.onSecondaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],

                      // Route info
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _InfoRow(Icons.circle, const Color(0xFF27C041),
                                  booking.pickupLocation.address),
                              const SizedBox(height: 8),
                              _InfoRow(Icons.circle, colorScheme.primary,
                                  booking.dropLocation.address),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Fare
                      Card(
                        child: ListTile(
                          leading: Icon(Icons.receipt_long,
                              color: colorScheme.secondary),
                          title: const Text('Estimated Fare'),
                          trailing: Text(
                            '\$${booking.estimatedFare.toStringAsFixed(2)}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Cancel button (only if not completed/cancelled)
                      if (BookingStatus.activeStates
                          .contains(booking.bookingStatus))
                        OutlinedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Cancel Ride'),
                                content: const Text(
                                    'Are you sure you want to cancel?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: const Text('No'),
                                  ),
                                  FilledButton(
                                    style: FilledButton.styleFrom(
                                        backgroundColor: colorScheme.error),
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                      context.read<BookingBloc>().add(
                                            BookingCancelRequested(
                                              bookingId: booking!.id,
                                              reason: 'Changed my mind',
                                            ),
                                          );
                                    },
                                    child: const Text('Cancel Ride'),
                                  ),
                                ],
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: colorScheme.error,
                            side: BorderSide(color: colorScheme.error),
                          ),
                          icon: const Icon(Icons.close),
                          label: const Text('Cancel Ride'),
                        ),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status) {
      BookingStatus.placed => const Color(0xFF9D9D9D),
      BookingStatus.driverAssigned => const Color(0xFF1EADFF),
      BookingStatus.accepted => const Color(0xFF1EADFF),
      BookingStatus.ongoing => const Color(0xFFD19D00),
      BookingStatus.onHold => const Color(0xFFFFC107),
      BookingStatus.completed => const Color(0xFF27C041),
      BookingStatus.cancelled => const Color(0xFFFE7235),
      BookingStatus.rejected => const Color(0xFFFE7235),
      _ => const Color(0xFF9D9D9D),
    };
  }

  String _statusLabel(String status) {
    return switch (status) {
      BookingStatus.placed => 'Searching for driver...',
      BookingStatus.driverAssigned => 'Driver assigned',
      BookingStatus.accepted => 'Driver is on the way',
      BookingStatus.ongoing => 'Ride in progress',
      BookingStatus.onHold => 'Ride paused',
      BookingStatus.completed => 'Ride completed',
      BookingStatus.cancelled => 'Ride cancelled',
      BookingStatus.rejected => 'Driver unavailable',
      _ => status,
    };
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _InfoRow(this.icon, this.color, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

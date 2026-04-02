import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../location/presentation/bloc/location_bloc.dart';
import '../../../payment/presentation/bloc/payment_bloc.dart';
import '../bloc/booking_bloc.dart';

class ConfirmBookingPage extends StatelessWidget {
  const ConfirmBookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Booking')),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingPlacedState) {
            context.go('/tracking/${state.booking.id}');
          } else if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: colorScheme.error),
            );
          }
        },
        builder: (context, state) {
          final locState = context.watch<LocationBloc>().state;
          if (locState is! FareEstimated) {
            return const Center(child: Text('Please select a vehicle first'));
          }

          final fare = locState.fare;
          final vehicle = locState.vehicleType;
          final payState = context.watch<PaymentBloc>().state;
          final selectedMethod = payState is PaymentMethodReady
              ? payState.method
              : AppConstants.paymentCash;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Route summary card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _SummaryRow(
                          icon: Icons.circle,
                          iconColor: const Color(0xFF27C041),
                          label: 'Pickup',
                          value: locState.pickup.address,
                        ),
                        const SizedBox(height: 12),
                        _SummaryRow(
                          icon: Icons.circle,
                          iconColor: colorScheme.primary,
                          label: 'Drop',
                          value: locState.drop.address,
                        ),
                        if (locState.stops.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _SummaryRow(
                            icon: Icons.more_vert,
                            iconColor: colorScheme.secondary,
                            label: 'Stops',
                            value: '${locState.stops.length} stop(s)',
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Vehicle & Distance
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _DetailRow('Vehicle', vehicle.name),
                        _DetailRow('Distance',
                            '${locState.distance.distanceInKm.toStringAsFixed(1)} km'),
                        _DetailRow('Est. Duration',
                            '${locState.distance.durationInMinutes.toStringAsFixed(0)} min'),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Fare breakdown
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fare Breakdown',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        _DetailRow('Base Fare',
                            '\$${fare.baseFare.toStringAsFixed(2)}'),
                        _DetailRow('Distance Charge',
                            '\$${fare.distanceCharge.toStringAsFixed(2)}'),
                        _DetailRow('Time Charge',
                            '\$${fare.timeCharge.toStringAsFixed(2)}'),
                        if (fare.nightCharge > 0)
                          _DetailRow('Night Charge',
                              '\$${fare.nightCharge.toStringAsFixed(2)}'),
                        _DetailRow(
                            'Tax', '\$${fare.taxAmount.toStringAsFixed(2)}'),
                        const Divider(),
                        _DetailRow(
                          'Total',
                          '\$${fare.totalAmount.toStringAsFixed(2)}',
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Payment method selection
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payment Method',
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 12),
                        _PaymentOption(
                          icon: Icons.money,
                          label: 'Cash',
                          value: AppConstants.paymentCash,
                          selected: selectedMethod,
                          onTap: () => context.read<PaymentBloc>().add(
                              const PaymentMethodSelected(
                                  AppConstants.paymentCash)),
                        ),
                        _PaymentOption(
                          icon: Icons.account_balance_wallet,
                          label: 'Wallet',
                          value: AppConstants.paymentWallet,
                          selected: selectedMethod,
                          onTap: () => context.read<PaymentBloc>().add(
                              const PaymentMethodSelected(
                                  AppConstants.paymentWallet)),
                        ),
                        _PaymentOption(
                          icon: Icons.credit_card,
                          label: 'Card (Stripe)',
                          value: AppConstants.paymentStripe,
                          selected: selectedMethod,
                          onTap: () => context.read<PaymentBloc>().add(
                              const PaymentMethodSelected(
                                  AppConstants.paymentStripe)),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Confirm button
                FilledButton(
                  onPressed: state is BookingCreating
                      ? null
                      : () {
                          final authState = context.read<AuthBloc>().state;
                          if (authState is! Authenticated) return;

                          context.read<BookingBloc>().add(
                                BookingCreateRequested(
                                  customerId: authState.user.id,
                                  pickup: locState.pickup,
                                  drop: locState.drop,
                                  stops: locState.stops,
                                  vehicleTypeId: vehicle.id,
                                  vehicleTypeName: vehicle.name,
                                  estimatedFare: fare.totalAmount,
                                  paymentType: selectedMethod,
                                ),
                              );
                        },
                  child: state is BookingCreating
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : Text('Book ${vehicle.name} - '
                          '\$${fare.totalAmount.toStringAsFixed(2)}'),
                ),

                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _SummaryRow({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 10, color: iconColor),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.5))),
            Text(value,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _DetailRow(this.label, this.value, {this.isBold = false});

  @override
  Widget build(BuildContext context) {
    final style = isBold
        ? Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }
}

class _PaymentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String selected;
  final VoidCallback onTap;

  const _PaymentOption({
    required this.icon,
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon,
          color: isSelected ? colorScheme.primary : colorScheme.outline),
      title: Text(label),
      trailing: isSelected
          ? Icon(Icons.check_circle, color: colorScheme.primary)
          : const Icon(Icons.circle_outlined),
      onTap: onTap,
    );
  }
}

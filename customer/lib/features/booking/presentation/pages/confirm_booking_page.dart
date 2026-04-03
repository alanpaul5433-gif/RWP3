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
      body: SafeArea(
        child: BlocConsumer<BookingBloc, BookingState>(
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

            return Column(
              children: [
                // ==================== Top Bar ====================
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back, size: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.local_taxi_rounded, color: colorScheme.primary, size: 22),
                      const SizedBox(width: 6),
                      Text(
                        AppConstants.appName,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // ==================== Content ====================
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          'Where to?',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Route card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            children: [
                              // Pickup
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF2E7D32),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      locState.pickup.address,
                                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 4),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    width: 2,
                                    height: 24,
                                    color: const Color(0xFFE8E5E0),
                                  ),
                                ),
                              ),
                              // Drop
                              Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      locState.drop.address,
                                      style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              if (locState.stops.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF5F2ED),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.add_circle_outline, size: 16),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${locState.stops.length} stop(s) added',
                                        style: theme.textTheme.labelMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Add stop
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(Icons.add_circle, color: colorScheme.primary, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                'Add Stop',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Ride type label
                        Text(
                          'SELECT RIDE',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Vehicle cards — fare breakdown
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: colorScheme.primary, width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'RECOMMENDED',
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(Icons.check_circle, color: colorScheme.primary, size: 22),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.directions_car, size: 40, color: colorScheme.onSurface.withValues(alpha: 0.6)),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(vehicle.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                                        Text(
                                          '${locState.distance.distanceInKm.toStringAsFixed(1)} km \u2022 ${locState.distance.durationInMinutes.toStringAsFixed(0)} min',
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$${fare.totalAmount.toStringAsFixed(2)}',
                                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Payment method
                        Text(
                          'PAYMENT',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                            letterSpacing: 1,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _PayChip(
                              icon: Icons.money,
                              label: 'Cash',
                              selected: selectedMethod == AppConstants.paymentCash,
                              onTap: () => context.read<PaymentBloc>().add(
                                  const PaymentMethodSelected(AppConstants.paymentCash)),
                            ),
                            const SizedBox(width: 8),
                            _PayChip(
                              icon: Icons.account_balance_wallet,
                              label: 'Wallet',
                              selected: selectedMethod == AppConstants.paymentWallet,
                              onTap: () => context.read<PaymentBloc>().add(
                                  const PaymentMethodSelected(AppConstants.paymentWallet)),
                            ),
                            const SizedBox(width: 8),
                            _PayChip(
                              icon: Icons.credit_card,
                              label: 'Card',
                              selected: selectedMethod == AppConstants.paymentStripe,
                              onTap: () => context.read<PaymentBloc>().add(
                                  const PaymentMethodSelected(AppConstants.paymentStripe)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // ==================== Bottom CTA ====================
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: FilledButton(
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
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Book '),
                              Text(
                                '${vehicle.name}',
                                style: const TextStyle(fontWeight: FontWeight.w800),
                              ),
                              Text(
                                '  \$${fare.totalAmount.toStringAsFixed(2)}',
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.arrow_forward, size: 18),
                            ],
                          ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PayChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _PayChip({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? colorScheme.primary.withValues(alpha: 0.08) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? colorScheme.primary : const Color(0xFFE8E5E0),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 20, color: selected ? colorScheme.primary : const Color(0xFF6B6B6B)),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                      color: selected ? colorScheme.primary : const Color(0xFF6B6B6B),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../bloc/subscriptions_bloc.dart';

class SubscriptionsPage extends StatelessWidget {
  const SubscriptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Subscription Plans', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 24),

      Expanded(child: BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
        builder: (context, state) {
          if (state is SubscriptionsLoading) return const Center(child: CircularProgressIndicator());
          final plans = state is SubscriptionsLoaded ? state.plans : <SubscriptionPlanEntity>[];

          return ListView.builder(itemCount: plans.length, itemBuilder: (context, index) {
            final plan = plans[index];
            return Card(margin: const EdgeInsets.only(bottom: 16), child: Padding(padding: const EdgeInsets.all(20), child: Row(children: [
              Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.star, color: colorScheme.onPrimaryContainer, size: 28)),
              const SizedBox(width: 20),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(plan.name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(plan.description, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6))),
                const SizedBox(height: 8),
                Row(children: [
                  Icon(Icons.calendar_today, size: 14, color: colorScheme.secondary), const SizedBox(width: 4),
                  Text('${plan.expiryDays} days', style: theme.textTheme.bodySmall),
                  const SizedBox(width: 16),
                  Icon(Icons.local_taxi, size: 14, color: colorScheme.secondary), const SizedBox(width: 4),
                  Text('${plan.totalBookings} bookings', style: theme.textTheme.bodySmall),
                ]),
              ])),
              Column(children: [
                Text('\$${plan.price.toStringAsFixed(2)}', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary)),
                Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: plan.isActive ? const Color(0xFF27C041).withValues(alpha: 0.1) : colorScheme.outline.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: Text(plan.isActive ? 'Active' : 'Inactive',
                        style: TextStyle(color: plan.isActive ? const Color(0xFF27C041) : colorScheme.outline, fontSize: 12, fontWeight: FontWeight.w600))),
              ]),
            ])));
          });
        },
      )),
    ]));
  }
}

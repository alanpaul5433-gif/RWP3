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

    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Subscription Plans', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              const SizedBox(width: 8),
              Text('Manage driver subscription tiers', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4))),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => _showPlanDialog(context, null),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Plan'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          Expanded(
            child: BlocBuilder<SubscriptionsBloc, SubscriptionsState>(
              builder: (context, state) {
                if (state is SubscriptionsLoading) return const Center(child: CircularProgressIndicator());
                if (state is SubscriptionsError) return Center(child: Text(state.message));
                final plans = state is SubscriptionsLoaded ? state.plans : <SubscriptionPlanEntity>[];
                if (plans.isEmpty) return Center(child: Text('No plans configured', style: theme.textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.3))));

                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.85,
                  ),
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    final plan = plans[index];
                    final tierColors = [colorScheme.onSurface, colorScheme.primary, const Color(0xFFDAA520)];
                    final tierColor = index < tierColors.length ? tierColors[index] : colorScheme.primary;

                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: index == 1 ? Border.all(color: colorScheme.primary, width: 2) : null,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: tierColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                                child: Text(plan.name, style: TextStyle(color: tierColor, fontWeight: FontWeight.w700, fontSize: 13)),
                              ),
                              const Spacer(),
                              if (!plan.isActive)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(color: colorScheme.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                                  child: Text('INACTIVE', style: TextStyle(color: colorScheme.error, fontSize: 10, fontWeight: FontWeight.w700)),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('\$${plan.price.toStringAsFixed(0)}', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800)),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 6, left: 4),
                                child: Text('/month', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4))),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(plan.description, style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5))),
                          const SizedBox(height: 16),
                          _FeatureRow(Icons.calendar_today, '${plan.expiryDays} day access'),
                          const SizedBox(height: 6),
                          _FeatureRow(Icons.local_taxi, '${plan.totalBookings} bookings/month'),
                          _FeatureRow(Icons.speed, 'Priority dispatch'),
                          const Spacer(),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _showPlanDialog(context, plan),
                                  style: OutlinedButton.styleFrom(minimumSize: const Size(0, 40), side: const BorderSide(color: Color(0xFFE8E5E0))),
                                  child: const Text('Edit'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () => _confirmDelete(context, plan),
                                icon: Icon(Icons.delete_outline, color: colorScheme.error, size: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPlanDialog(BuildContext context, SubscriptionPlanEntity? existing) {
    final isEdit = existing != null;
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    final priceCtrl = TextEditingController(text: existing?.price.toStringAsFixed(0) ?? '');
    final daysCtrl = TextEditingController(text: existing?.expiryDays.toString() ?? '30');
    final bookingsCtrl = TextEditingController(text: existing?.totalBookings.toString() ?? '50');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isEdit ? 'Edit Plan' : 'Create New Plan'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Plan Name', hintText: 'e.g. Gold')),
              const SizedBox(height: 12),
              TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price (\$)', prefixText: '\$ '))),
                  const SizedBox(width: 12),
                  Expanded(child: TextField(controller: daysCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Days'))),
                ],
              ),
              const SizedBox(height: 12),
              TextField(controller: bookingsCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Max Bookings')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final plan = SubscriptionPlanEntity(
                id: existing?.id ?? '',
                name: nameCtrl.text, description: descCtrl.text,
                price: double.tryParse(priceCtrl.text) ?? 0,
                expiryDays: int.tryParse(daysCtrl.text) ?? 30,
                totalBookings: int.tryParse(bookingsCtrl.text) ?? 50,
              );
              Navigator.pop(ctx);
              if (isEdit) {
                context.read<SubscriptionsBloc>().add(SubscriptionUpdateRequested(plan));
              } else {
                context.read<SubscriptionsBloc>().add(SubscriptionCreateRequested(plan));
              }
            },
            child: Text(isEdit ? 'Update' : 'Create'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, SubscriptionPlanEntity plan) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Plan'),
        content: Text('Are you sure you want to delete "${plan.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () {
              Navigator.pop(ctx);
              context.read<SubscriptionsBloc>().add(SubscriptionDeleteRequested(plan.id));
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FeatureRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF2E7D32)),
          const SizedBox(width: 8),
          Text(text, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

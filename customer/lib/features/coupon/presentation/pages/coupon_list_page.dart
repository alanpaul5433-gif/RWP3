import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../bloc/coupon_bloc.dart';

class CouponListPage extends StatelessWidget {
  const CouponListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Coupons')),
      body: BlocBuilder<CouponBloc, CouponState>(
        builder: (context, state) {
          if (state is CouponLoading) return const Center(child: CircularProgressIndicator());
          if (state is CouponError) return Center(child: Text(state.message));

          final coupons = state is CouponsLoaded ? state.coupons : <CouponEntity>[];

          if (coupons.isEmpty) {
            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.local_offer_outlined, size: 48, color: colorScheme.outline),
              const SizedBox(height: 12),
              Text('No coupons available', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline)),
            ]));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: coupons.length,
            itemBuilder: (context, index) {
              final coupon = coupons[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                        child: Icon(Icons.local_offer, color: colorScheme.onPrimaryContainer),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(coupon.code, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1)),
                        const SizedBox(height: 4),
                        Text(coupon.isPercentage ? '${coupon.discount.toStringAsFixed(0)}% off' : '\$${coupon.discount.toStringAsFixed(0)} off',
                            style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.primary)),
                        Text('Min order: \$${coupon.minOrderAmount.toStringAsFixed(0)}', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5))),
                      ])),
                      FilledButton.tonal(
                        onPressed: () => Navigator.pop(context, coupon),
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:core/core.dart';
import '../bloc/loyalty_bloc.dart';

class LoyaltyPage extends StatelessWidget {
  const LoyaltyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Loyalty Points')),
      body: BlocBuilder<LoyaltyBloc, LoyaltyState>(
        builder: (context, state) {
          if (state is LoyaltyLoading) return const Center(child: CircularProgressIndicator());
          if (state is LoyaltyError) return Center(child: Text(state.message));
          if (state is! LoyaltyLoaded) return const SizedBox.shrink();

          return Column(children: [
            // Balance card
            Container(
              width: double.infinity, margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [colorScheme.secondary, colorScheme.secondary.withValues(alpha: 0.8)]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Loyalty Credits', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                const SizedBox(height: 8),
                Text('${state.credits.toStringAsFixed(0)} pts', style: theme.textTheme.headlineLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Earn points on every ride', style: theme.textTheme.bodySmall?.copyWith(color: Colors.white60)),
              ]),
            ),

            Padding(padding: const EdgeInsets.symmetric(horizontal: 16), child: Align(alignment: Alignment.centerLeft,
                child: Text('History', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)))),
            const SizedBox(height: 8),

            Expanded(child: state.transactions.isEmpty
                ? Center(child: Text('No transactions yet', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outline)))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.transactions.length,
                    separatorBuilder: (_, idx) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final txn = state.transactions[index];
                      final isEarned = txn.action == 'earned';
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isEarned ? const Color(0xFF27C041).withValues(alpha: 0.1) : colorScheme.error.withValues(alpha: 0.1),
                          child: Icon(isEarned ? Icons.add : Icons.remove, color: isEarned ? const Color(0xFF27C041) : colorScheme.error, size: 20),
                        ),
                        title: Text('${txn.action.toUpperCase()} ${txn.points.toStringAsFixed(0)} pts'),
                        subtitle: Text('${txn.createdAt.day}/${txn.createdAt.month}/${txn.createdAt.year}', style: theme.textTheme.bodySmall),
                      );
                    },
                  )),
          ]);
        },
      ),
    );
  }
}

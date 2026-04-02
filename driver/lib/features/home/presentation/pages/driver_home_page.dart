import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/driver_auth_bloc.dart';
import '../bloc/driver_home_bloc.dart';

class DriverHomePage extends StatelessWidget {
  const DriverHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('RWP3 Driver'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
        ],
      ),
      body: BlocBuilder<DriverHomeBloc, DriverHomeState>(
        builder: (context, state) {
          if (state is DriverHomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final isOnline = state is DriverHomeDashboardLoaded ? state.isOnline : false;
          final stats = state is DriverHomeDashboardLoaded ? state.stats : <String, int>{};

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Online/Offline toggle
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(isOnline ? 'You are Online' : 'You are Offline',
                                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(isOnline ? 'Receiving ride requests' : 'Toggle to start receiving rides',
                                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6))),
                          ],
                        ),
                        const Spacer(),
                        BlocBuilder<DriverAuthBloc, DriverAuthState>(
                          builder: (context, authState) {
                            final driverId = authState is DriverAuthenticated ? authState.driver.id : '';
                            return Switch.adaptive(
                              value: isOnline,
                              activeColor: const Color(0xFF27C041),
                              onChanged: (v) => context.read<DriverHomeBloc>().add(
                                    DriverStatusToggled(driverId: driverId, online: v),
                                  ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Stats
                if (stats.isNotEmpty) ...[
                  Text('Today\'s Stats', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _StatChip('New', stats['new'] ?? 0, const Color(0xFF1EADFF)),
                      _StatChip('Ongoing', stats['ongoing'] ?? 0, const Color(0xFFD19D00)),
                      _StatChip('Completed', stats['completed'] ?? 0, const Color(0xFF27C041)),
                      _StatChip('Rejected', stats['rejected'] ?? 0, const Color(0xFFFE7235)),
                      _StatChip('Cancelled', stats['cancelled'] ?? 0, const Color(0xFF9D9D9D)),
                    ],
                  ),
                ],

                const SizedBox(height: 24),

                // Quick actions
                Row(
                  children: [
                    _ActionCard(icon: Icons.account_balance_wallet, label: 'Wallet', color: colorScheme.secondary, onTap: () {}),
                    const SizedBox(width: 12),
                    _ActionCard(icon: Icons.description, label: 'Documents', color: const Color(0xFFE65100), onTap: () {}),
                    const SizedBox(width: 12),
                    _ActionCard(icon: Icons.account_balance, label: 'Bank', color: const Color(0xFF2E7D32), onTap: () {}),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _StatChip(this.label, this.count, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text('$count', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 12, color: color)),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionCard({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(height: 8),
                Text(label, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

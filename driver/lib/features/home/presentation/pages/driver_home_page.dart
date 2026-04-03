import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../../../auth/presentation/bloc/driver_auth_bloc.dart';
import '../bloc/driver_home_bloc.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: _navIndex == 0 ? const _DashboardContent() : Center(child: Text(['Dashboard', 'Rides', 'Earnings', 'Profile'][_navIndex])),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, -4))],
        ),
        child: BottomNavigationBar(
          currentIndex: _navIndex,
          onTap: (i) {
            if (i == 0) setState(() => _navIndex = 0);
            else if (i == 1) context.push('/rides');
            else if (i == 2) context.push('/earnings');
            else if (i == 3) context.push('/settings');
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.local_taxi_rounded), label: 'Rides'),
            BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Earnings'),
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final cardColor = cs.surface;

    return SafeArea(
      child: BlocBuilder<DriverHomeBloc, DriverHomeState>(
        builder: (context, state) {
          final isOnline = state is DriverHomeDashboardLoaded ? state.isOnline : false;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==================== Top Bar ====================
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Text('RWP', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, color: cs.primary, letterSpacing: 1)),
                      const SizedBox(width: 12),
                      BlocBuilder<DriverAuthBloc, DriverAuthState>(
                        builder: (context, authState) {
                          final driverId = authState is DriverAuthenticated ? authState.driver.id : '';
                          return GestureDetector(
                            onTap: () => context.read<DriverHomeBloc>().add(DriverStatusToggled(driverId: driverId, online: !isOnline)),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: isOnline ? const Color(0xFF2E7D32).withValues(alpha: 0.1) : cs.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                Container(width: 8, height: 8, decoration: BoxDecoration(
                                  color: isOnline ? const Color(0xFF2E7D32) : cs.primary, shape: BoxShape.circle)),
                                const SizedBox(width: 6),
                                Text(isOnline ? 'ONLINE' : 'OFFLINE', style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.w700, color: isOnline ? const Color(0xFF2E7D32) : cs.primary, letterSpacing: 0.5)),
                              ]),
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20), border: Border.all(color: cs.outline)),
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          const Icon(Icons.flash_on, size: 14, color: Color(0xFFDAA520)),
                          const SizedBox(width: 4),
                          Text('LIVE', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700)),
                        ]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==================== Earnings Card ====================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: cs.primary, borderRadius: BorderRadius.circular(24)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text('CURRENT SESSION', style: theme.textTheme.labelSmall?.copyWith(color: Colors.white.withValues(alpha: 0.6), letterSpacing: 1)),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                          child: Text(isOnline ? 'LIVE' : 'OFF', style: theme.textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      Text('\$482.50', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, color: Colors.white)),
                      Text('8.5 Hours active today', style: theme.textTheme.bodySmall?.copyWith(color: Colors.white.withValues(alpha: 0.6))),
                      const SizedBox(height: 20),
                      Row(children: [
                        _ToggleChip('Daily', true),
                        const SizedBox(width: 8),
                        _ToggleChip('Weekly', false),
                      ]),
                    ]),
                  ),
                ),

                const SizedBox(height: 20),

                // ==================== Stats Row ====================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    _MiniStat('RIDES', '24', cardColor),
                    const SizedBox(width: 10),
                    _MiniStat('TIPS', '\$64.00', cardColor),
                    const SizedBox(width: 10),
                    _MiniStat('TIME', '8.5h', cardColor),
                    const SizedBox(width: 10),
                    _MiniStat('ACCEPT', '82%', cardColor),
                  ]),
                ),

                const SizedBox(height: 24),

                // ==================== Rating ====================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                    child: Row(children: [
                      const Icon(Icons.star, color: Color(0xFFDAA520), size: 22),
                      const SizedBox(width: 10),
                      Text('4.98 Rating', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                      Text('  \u2022  ', style: TextStyle(color: cs.onSurface.withValues(alpha: 0.2))),
                      Text('Diamond Member', style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.5))),
                    ]),
                  ),
                ),

                const SizedBox(height: 16),

                // ==================== Surge Zones ====================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(16)),
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: cs.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                        child: Icon(Icons.local_fire_department, size: 18, color: cs.primary),
                      ),
                      const SizedBox(width: 12),
                      Text('Surge Zones', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                      const Spacer(),
                      Text('3 active', style: theme.textTheme.bodySmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right, size: 18, color: cs.primary),
                    ]),
                  ),
                ),

                const SizedBox(height: 24),

                // ==================== Recent Activity ====================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    Text('Recent Activity', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const Spacer(),
                    Text('View History', style: theme.textTheme.labelMedium?.copyWith(color: cs.primary, fontWeight: FontWeight.w600)),
                  ]),
                ),
                const SizedBox(height: 12),

                // Mock ride request
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20)),
                    child: Column(children: [
                      Row(children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: cs.primary.withValues(alpha: 0.1),
                          child: Icon(Icons.person, color: cs.primary, size: 22),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            Text('Marcus', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                            const SizedBox(width: 6),
                            const Icon(Icons.star, color: Color(0xFFDAA520), size: 12),
                            Text(' 4.9', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
                          ]),
                          Text('Grand Hyatt \u2192 City Airport', style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurface.withValues(alpha: 0.5))),
                        ])),
                        Text('\$34.50', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                      ]),
                      const SizedBox(height: 14),
                      Row(children: [
                        Expanded(child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(minimumSize: const Size(0, 44), foregroundColor: cs.onSurface.withValues(alpha: 0.6), side: BorderSide(color: cs.outline)),
                          child: const Text('Reject'),
                        )),
                        const SizedBox(width: 12),
                        Expanded(child: FilledButton(
                          onPressed: () {},
                          style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
                          child: const Text('ACCEPT RIDE'),
                        )),
                      ]),
                    ]),
                  ),
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

class _ToggleChip extends StatelessWidget {
  final String label;
  final bool active;
  const _ToggleChip(this.label, this.active);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: TextStyle(
        fontSize: 13, fontWeight: FontWeight.w700,
        color: active ? const Color(0xFFC41E24) : Colors.white.withValues(alpha: 0.6),
      )),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color bgColor;
  const _MiniStat(this.label, this.value, this.bgColor);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(14)),
        child: Column(children: [
          Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 2),
          Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4), fontSize: 10)),
        ]),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';
import '../bloc/intercity_bloc.dart';

class IntercityPage extends StatefulWidget {
  const IntercityPage({super.key});

  @override
  State<IntercityPage> createState() => _IntercityPageState();
}

class _IntercityPageState extends State<IntercityPage> {
  String _rideType = 'personal';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
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
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.menu, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('RWP', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, color: colorScheme.primary, letterSpacing: 1)),
                  const Spacer(),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                    child: Icon(Icons.person, size: 18, color: colorScheme.primary),
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
                    const SizedBox(height: 8),
                    Text('Beyond', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, height: 1.1)),
                    Text('Boundaries', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, fontStyle: FontStyle.italic, color: colorScheme.onSurface.withValues(alpha: 0.4), height: 1.1)),
                    const SizedBox(height: 8),
                    Text('Luxury intercity travel, redefined.', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5))),

                    const SizedBox(height: 28),

                    // Pickup / Drop
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        children: [
                          _LocationRow(icon: Icons.circle, color: const Color(0xFF2E7D32), label: 'PICK-UP', value: 'San Francisco, CA', subtitle: 'The Financial District'),
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Align(alignment: Alignment.centerLeft, child: Container(width: 2, height: 20, color: const Color(0xFFE8E5E0))),
                          ),
                          _LocationRow(icon: Icons.circle, color: colorScheme.primary, label: 'DROP-OFF', value: 'Los Angeles, CA', subtitle: 'Santa Monica Pier'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Personal / Shared toggle
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                      child: Row(
                        children: [
                          _TabChip('Personal', _rideType == 'personal', () => setState(() => _rideType = 'personal')),
                          _TabChip('Shared', _rideType == 'shared', () => setState(() => _rideType = 'shared')),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Vehicle card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: colorScheme.primary, width: 2),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(8)),
                            child: Text('RWP ELITE', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                          ),
                          const SizedBox(height: 12),
                          Text('GRAND SEDAN', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 1)),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.schedule, size: 14, color: colorScheme.onSurface.withValues(alpha: 0.4)),
                              const SizedBox(width: 4),
                              Text('5h 45m', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5))),
                              const SizedBox(width: 16),
                              Icon(Icons.people, size: 14, color: colorScheme.onSurface.withValues(alpha: 0.4)),
                              const SizedBox(width: 4),
                              Text('Up to 3', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5))),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Car placeholder
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(color: const Color(0xFFF5F2ED), borderRadius: BorderRadius.circular(14)),
                            child: Center(child: Icon(Icons.directions_car, size: 60, color: colorScheme.onSurface.withValues(alpha: 0.15))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ==================== Bottom Nav ====================
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, -4))],
              ),
              child: BottomNavigationBar(
                currentIndex: 0,
                onTap: (i) { if (i == 0) context.go('/home'); },
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.route_rounded), label: 'Rides'),
                  BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'Parcel'),
                  BottomNavigationBarItem(icon: Icon(Icons.card_membership), label: 'Plans'),
                  BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Account'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final String subtitle;
  const _LocationRow({required this.icon, required this.color, required this.label, required this.value, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.4), letterSpacing: 0.5, fontSize: 10)),
              Text(value, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
            ],
          ),
        ),
      ],
    );
  }
}

class _TabChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _TabChip(this.label, this.active, this.onTap);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? colorScheme.onSurface : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: active ? Colors.white : colorScheme.onSurface.withValues(alpha: 0.5))),
          ),
        ),
      ),
    );
  }
}

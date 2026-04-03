import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/admin_auth_bloc.dart';

class AdminShell extends StatefulWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _selectedIndex = 0;

  static const _navItems = [
    _NavItem(Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
    _NavItem(Icons.people_outlined, Icons.people, 'Users'),
    _NavItem(Icons.drive_eta_outlined, Icons.drive_eta, 'Drivers'),
    _NavItem(Icons.receipt_long_outlined, Icons.receipt_long, 'Bookings'),
    _NavItem(Icons.directions_car_outlined, Icons.directions_car, 'Vehicles'),
    _NavItem(Icons.location_on_outlined, Icons.location_on, 'Zones'),
    _NavItem(Icons.card_membership_outlined, Icons.card_membership, 'Plans'),
    _NavItem(Icons.image_outlined, Icons.image, 'Banners'),
    _NavItem(Icons.admin_panel_settings_outlined, Icons.admin_panel_settings, 'Roles'),
  ];

  static const _routes = ['/dashboard', '/customers', '/drivers', '/bookings', '/vehicles', '/zones', '/subscriptions', '/banners', '/roles'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isWide = MediaQuery.of(context).size.width > 1200;

    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _routes.length; i++) {
      if (location.startsWith(_routes[i])) { _selectedIndex = i; break; }
    }

    return Scaffold(
      body: Row(
        children: [
          // ==================== Sidebar ====================
          Container(
            width: isWide ? 220 : 72,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: const Color(0xFFE8E5E0), width: 1)),
            ),
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Brand
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isWide ? 20 : 12),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.local_taxi, color: Colors.white, size: 18),
                      ),
                      if (isWide) ...[
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('RWP', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w800, color: colorScheme.primary, letterSpacing: 1)),
                            Text('Admin', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4))),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Nav items
                ...List.generate(_navItems.length, (i) {
                  final item = _navItems[i];
                  final isSelected = i == _selectedIndex;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: isWide ? 12 : 8, vertical: 2),
                    child: Material(
                      color: isSelected ? colorScheme.primary.withValues(alpha: 0.08) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () { setState(() => _selectedIndex = i); context.go(_routes[i]); },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: isWide ? 14 : 12, vertical: 12),
                          child: Row(
                            children: [
                              Icon(
                                isSelected ? item.selectedIcon : item.icon,
                                size: 20,
                                color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.4),
                              ),
                              if (isWide) ...[
                                const SizedBox(width: 12),
                                Text(
                                  item.label,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                    color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                const Spacer(),

                // Bottom actions
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isWide ? 12 : 8),
                  child: Column(
                    children: [
                      _BottomNavItem(icon: Icons.settings_outlined, label: 'Settings', isWide: isWide, onTap: () => context.go('/settings')),
                      _BottomNavItem(icon: Icons.logout, label: 'Logout', isWide: isWide, isDestructive: true,
                        onTap: () => context.read<AdminAuthBloc>().add(const AdminLogoutRequested())),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // ==================== Content ====================
          Expanded(child: widget.child),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  const _NavItem(this.icon, this.selectedIcon, this.label);
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isWide;
  final bool isDestructive;
  final VoidCallback onTap;
  const _BottomNavItem({required this.icon, required this.label, required this.isWide, this.isDestructive = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isWide ? 14 : 12, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: color),
              if (isWide) ...[
                const SizedBox(width: 12),
                Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w500)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

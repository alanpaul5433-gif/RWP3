import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:core/core.dart';

class RentalPage extends StatefulWidget {
  const RentalPage({super.key});

  @override
  State<RentalPage> createState() => _RentalPageState();
}

class _RentalPageState extends State<RentalPage> {
  int _selectedPackage = 1;

  final _packages = const [
    _RentalPackageData(hours: 1, km: 10, price: 15.00),
    _RentalPackageData(hours: 2, km: 25, price: 28.00),
    _RentalPackageData(hours: 4, km: 50, price: 50.00),
    _RentalPackageData(hours: 8, km: 100, price: 90.00),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.arrow_back, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(AppConstants.appName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, color: colorScheme.primary)),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text('Rent a', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, height: 1.1)),
                    Text('Vehicle.', style: theme.textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, color: colorScheme.primary, height: 1.1)),
                    const SizedBox(height: 8),
                    Text('Choose a rental package. Extra hours and KM charged separately.', style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5))),

                    const SizedBox(height: 24),

                    // Pickup location
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: const Color(0xFF2E7D32).withValues(alpha: 0.08), borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.my_location, size: 18, color: Color(0xFF2E7D32)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('PICKUP LOCATION', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4), letterSpacing: 0.5, fontSize: 10)),
                                Text('Current Location', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                          Icon(Icons.edit_outlined, size: 18, color: colorScheme.primary),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Packages
                    Text('SELECT PACKAGE', style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4), letterSpacing: 1, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),

                    ...List.generate(_packages.length, (i) {
                      final pkg = _packages[i];
                      final isSelected = i == _selectedPackage;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedPackage = i),
                          child: Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: isSelected ? colorScheme.primary : const Color(0xFFE8E5E0), width: isSelected ? 2 : 1),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isSelected ? colorScheme.primary.withValues(alpha: 0.08) : const Color(0xFFF5F2ED),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.access_time_rounded, size: 20, color: isSelected ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.4)),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${pkg.hours}h Package', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                                      Text('${pkg.km} KM included', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5))),
                                    ],
                                  ),
                                ),
                                Text('\$${pkg.price.toStringAsFixed(2)}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: isSelected ? colorScheme.primary : colorScheme.onSurface)),
                                if (isSelected) ...[
                                  const SizedBox(width: 8),
                                  Icon(Icons.check_circle, color: colorScheme.primary, size: 22),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 16),

                    // Extra charges info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDAA520).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xFFDAA520).withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, size: 18, color: Color(0xFFDAA520)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Extra hours: \$12/hr \u2022 Extra KM: \$2/km',
                              style: theme.textTheme.bodySmall?.copyWith(color: const Color(0xFFDAA520), fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom CTA
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 16, offset: const Offset(0, -4))],
              ),
              child: FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rental booked successfully! Finding a driver...')));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Book Rental'),
                    const SizedBox(width: 8),
                    Text('\$${_packages[_selectedPackage].price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RentalPackageData {
  final int hours;
  final int km;
  final double price;
  const _RentalPackageData({required this.hours, required this.km, required this.price});
}
